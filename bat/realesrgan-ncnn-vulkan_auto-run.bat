@echo off
cd "%~dp0"

if exist "input" (
	if exist "output" (
		echo "directory exist : OK"
	) else (
		echo "ディレクトリ [output] が存在しないため、該当ディレクトリを作成します。"
		md "output"
	)

	for /F "delims=" %%A in ('dir /b input') do (
		echo "%%A"
		"realesrgan-ncnn-vulkan.exe" -i "input\%%A" -o "output\%%A" -n realesrgan-x4plus-anime -s 4
	)

) else (
	echo "ディレクトリ [input] が存在しないため、該当ディレクトリを作成します。"
	echo "ディレクトリ [input] に処理したいファイルをコピーして再度実行してください。"
	md "input"
)