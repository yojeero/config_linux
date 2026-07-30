# ----------------------------------
# 7zip command
# ----------------------------------

7z x archive.7z / # extract to current directory
7z x archive.7z -o./mydir / # unpack to a specific directory
7z e archive.7z / # unpack without saving directory structure
7z a archive.7z myfile.txt / # pack one file
7z a archive myfile1.txt myfile2.txt myfile3.txt / # pack multiple files
7z a archive.7z /path/to/mydir / # pack the directory and its contents
7z a archive.7z myfile123.txt / # add files to an existing archive
7z l archive.7z / # view files in archive
7z t archive.7z / # test archive integrity
