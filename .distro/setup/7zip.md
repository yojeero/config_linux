
# ====================================
# 7zip command
# ====================================
7z x archive.7z / extract to current directory
7z x archive.7z -o./mydir / unpack to a specific directory
7z e archive.7z / unpack without saving directory structure
7z a archive.7z myfile.txt / pack one file
7z a archive myfile1.txt myfile2.txt myfile3.txt / pack multiple files
7z a archive.7z /path/to/mydir / pack the directory and its contents
7z a archive.7z myfile123.txt / add files to an existing archive
7z l archive.7z / view files in archive
7z t archive.7z / test archive integrity

# ====================================
# Micro Keybidings
# To see Micro’s default keybindings, type ctlr + e to enter command mode and then type “help"
# ====================================
Ctrl + q = Quit
Ctrl + o = Open
Ctrl + s = Save
Ctrl + f = Find
Ctrl + n = Find next
Ctrl + p = Find previous
Ctrl + z = Undo
Ctrl + y = Redo
Ctrl + c = Copy
Ctrl + x = Cut
Ctrl + k = Cut line
Ctrl + v = Paste
Ctrl + a = Select all
Ctrl + l = Jump line
PageUp = Cusor moves up a full page
PageDown = Cursor moves down a full page
Ctrl + w = Next split
Ctrl + t = Add a Tab
Ctrl + / = Next Tab
Ctrl + b = Shell mode
Alt + left/right = move the cursor a word in that direction
Ctrl + u = Toggle Macro (recoding keystrokes?)
Ctrl + j = Play Macro (play recorded steps)