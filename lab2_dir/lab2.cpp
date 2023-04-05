#include <iostream>
#include <vector>
#include <dirent.h>
#include <string>
#include <fstream> 

using namespace std;

bool find_number( string magic_number, string file_name) {
    ifstream fileInput;
    int offset;
    string line;
    fileInput.open(file_name.c_str());

    while( getline(fileInput, line)) {
        if ( line.find(magic_number, 0) != string::npos) {
            fileInput.close();
            return true;
        }
    }
    fileInput.close();

    return false;
}

int getdir(string dir, string magic_number, bool &find) { 
    DIR *dp;//創立資料夾指標
    struct dirent *dirp;
    bool findnow = false;
    if((dp = opendir(dir.c_str())) == NULL) {
        return 0;
    }

    while((dirp = readdir(dp)) != NULL) {//如果dirent指標非空
        string name = dirp->d_name;
        string file_path = dir + "/" + dirp->d_name;
        if ( dirp->d_type == DT_DIR && name != "." &&  name != ".." )
            getdir( file_path, magic_number, find );    
        else 
            findnow = find_number(magic_number, file_path ) ; 
   

        if( !find  && findnow ) {
            find = findnow;
            cout << file_path <<  endl;
            closedir(dp);
            return 0;
        }

    }
    closedir(dp);//關閉資料夾指標
    return 0;
}

int main( int argc, const char * argv[] ) {
    string magic_number = argv[2];
    string dir = argv[1];
    bool  find = false;
    if( argc == 3 ) {
       getdir( dir, magic_number, find );
    }
    else
        cout << "error" << endl;
    return 0;
}