/*
 * Lab problem set for UNIX programming course
 * by Chun-Ying Huang <chuang@cs.nctu.edu.tw>
 * License: GPLv2
 */
#include <linux/module.h>	// included for all kernel modules
#include <linux/kernel.h>	// included for KERN_INFO
#include <linux/init.h>		// included for __init and __exit macros
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/errno.h>
#include <linux/sched.h>	// task_struct requried for current_uid()
#include <linux/cred.h>		// for current_uid();
#include <linux/slab.h>		// for kmalloc/kfree
#include <linux/uaccess.h>	// copy_to_user
#include <linux/string.h>
#include <linux/device.h>
#include <linux/cdev.h>
#include <linux/mm.h>
#include <asm/io.h>
#include "kshram.h"


#define NUM_DEVICES 8
static dev_t devnum;
static struct class *clazz;

typedef struct __devpage__{
	unsigned long dev_size;
	void* dev_info;
    struct cdev c_dev;
}dev_page;
dev_page dev_pages[NUM_DEVICES];

// void* m_page[NUM_DEVICES];
// long  m_size[NUM_DEVICES];
dev_page *now_page;


static int kshram_dev_open(struct inode *i, struct file *f) {
	printk(KERN_INFO "kshram: device opened.\n");
    // struct kshram_dev *dev;
	//error: ISO C90 forbids mixed declarations and code [-Werror=declaration-after-statement]

    now_page  = container_of(i->i_cdev, dev_page, c_dev);
    f->private_data = now_page;
	return 0;
}

static int kshram_dev_close(struct inode *i, struct file *f) {
	printk(KERN_INFO "kshram: device closed.\n");
	return 0;
}

static ssize_t kshram_dev_read(struct file *f, char __user *buf, size_t len, loff_t *off) {
	printk(KERN_INFO "kshram: read %zu bytes @ %llu.\n", len, *off);
	return len;
}

static ssize_t kshram_dev_write(struct file *f, const char __user *buf, size_t len, loff_t *off) {
	printk(KERN_INFO "kshram: write %zu bytes @ %llu.\n", len, *off);
	return len;
}

static long kshram_dev_ioctl(struct file *fp, unsigned int cmd, unsigned long arg) {
    now_page = (dev_page*)(fp -> private_data);

	printk(KERN_INFO "kshram: ioctl cmd=%u arg=%lu.\n", cmd, arg);
    if( cmd == KSHRAM_GETSLOTS )
        return NUM_DEVICES;
    else if( cmd == KSHRAM_GETSIZE)
        return now_page->dev_size;
    else if ( cmd == KSHRAM_SETSIZE) {
        ClearPageReserved(virt_to_page(now_page->dev_info));
        now_page->dev_info = krealloc(now_page->dev_info, arg, GFP_KERNEL);
        now_page->dev_size = arg;
    } 

	return 0;
}

static int kshram_dev_mmap(struct file *fp, struct vm_area_struct *vma) {
	unsigned long phys_addr, vsize;

	printk(KERN_INFO "kshram: ddev_mmap.\n");
    now_page = (dev_page*)(fp -> private_data);
    phys_addr = virt_to_phys(now_page->dev_info);
    vsize = vma->vm_end - vma->vm_start;


    if (vsize > now_page->dev_size)
        return -EINVAL;

    /* 分配一段虚拟地址空间 */
    if (remap_pfn_range(vma, vma->vm_start, phys_addr >> PAGE_SHIFT, vsize, vma->vm_page_prot)) {
        printk(KERN_ERR "remap_pfn_range failed\n");
        return -EAGAIN;
    }

    // dev->mmap_addr = vma->vm_start;
    return 0;
} // kshram_dev_mmap

static const struct file_operations kshram_dev_fops = {
	.owner = THIS_MODULE,
	.open = kshram_dev_open,
	.read = kshram_dev_read,
	.write = kshram_dev_write,
	.unlocked_ioctl = kshram_dev_ioctl,
	.release = kshram_dev_close,
    .mmap = kshram_dev_mmap
};


static int kshram_proc_read(struct seq_file *m, void *v) {
	// char buf[] = "`hello, world!` in /proc.\n";
    //	seq_printf(m, buf);
    for(int i = 0; i < NUM_DEVICES; i++ ){
		seq_printf(m, "%02d: %lu\n", i, dev_pages[i].dev_size);
	} // for 
	return 0;
}

static int kshram_proc_open(struct inode *inode, struct file *file) {
	return single_open(file, kshram_proc_read, NULL);
}

static const struct proc_ops kshram_proc_fops = {
	.proc_open = kshram_proc_open,
	.proc_read = seq_read,
	.proc_lseek = seq_lseek,
	.proc_release = single_release
};

static char *kshram_devnode(const struct device *dev, umode_t *mode) {
	if(mode == NULL) return NULL;
	*mode = 0666;
	return NULL;
}

static int __init kshram_init(void) {
	// create char dev
    int i = 0;
	if(alloc_chrdev_region(&devnum, 0, 8, "updev") < 0)
		return -1;
	if((clazz = class_create(THIS_MODULE, "upclass")) == NULL)
		goto release_region;
	clazz->devnode = kshram_devnode;

    for( i = 0; i < NUM_DEVICES; i++) {
		if(device_create(clazz, NULL, devnum+i, NULL, "kshram%d", i) == NULL)
            goto release_class;
        cdev_init(&dev_pages[i].c_dev, &kshram_dev_fops);
        if(cdev_add(&dev_pages[i].c_dev, devnum+i, 1) == -1)
            goto release_cdevs;
	
		dev_pages[i].dev_size = 4096;
		dev_pages[i].dev_info = kzalloc(4096, GFP_KERNEL);
		// printk(KERN_INFO "kshram%u: %lu bytes allocated @ %px\n", i, dev_pages[i].dev_size, dev_pages[i].dev_info);

		SetPageReserved(virt_to_page(dev_pages[i].dev_info));

    }
	// create proc
    proc_create("kshram", 0, NULL, &kshram_proc_fops);

	printk(KERN_INFO "kshram: initialized.\n");
	return 0;   // Non-zero return means that the module couldn't be loaded.


release_cdevs:
    for (--i; i >= 0; --i) cdev_del(&dev_pages[i].c_dev);
	device_destroy(clazz,devnum);
release_class:
    class_destroy(clazz);
release_region:
	unregister_chrdev_region(devnum, NUM_DEVICES);
	return -1;
}

static void __exit kshram_cleanup(void)
{
	remove_proc_entry("kshram", NULL);

    // int i = 0;

    for (int i = 0; i < NUM_DEVICES; i++) {
		ClearPageReserved(virt_to_page(dev_pages[i].dev_info));
		kfree(dev_pages[i].dev_info);
        cdev_del(&dev_pages[i].c_dev);
		device_destroy(clazz, devnum+i);
    }    


    // for (i = 0; i < NUM_DEVICES; ++i)
    //     device_destroy(clazz, devnum);
	class_destroy(clazz);
	unregister_chrdev_region(devnum, NUM_DEVICES);

	printk(KERN_INFO "kshram: cleaned up.\n");
}

module_init(kshram_init);
module_exit(kshram_cleanup);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("HMN");
MODULE_DESCRIPTION("The unix programming course demo kernel module.");