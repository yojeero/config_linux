for /d %%X in (*) do (
	"C:\Program Files\7-Zip\7z.exe" a -ttar -so "%%X.tar" "%%X" | "C:\Program Files\7-Zip\7z.exe" a -si -txz "%%X.tar.xz"
	del "%%X.tar"
)
