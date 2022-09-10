@echo off
cd "%~dp0"

if exist "video" (

	if exist "temp" (
		echo "temp exist : OK"
	) else (
		echo "ディレクトリ [temp] が存在しないため、該当ディレクトリを作成します。"
		md "temp"
	)

	if exist "temp\video_tmp" (
		echo "video_tmp exist : OK"
	) else (
		echo "ディレクトリ [video_tmp] が存在しないため、該当ディレクトリを作成します。"
		md "temp\video_tmp"
	)

	del /S /Q "temp\video_tmp" > nul
	del /S /Q "temp\frame_tmp" > nul

	for /F "delims=" %%B in ('dir /b video') do (

		if exist "temp\frame_tmp" ( 
			echo "frame_tmp exist : OK" 
		) else (
			echo "ディレクトリ [frame_tmp] が存在しないため、該当ディレクトリを作成します。"
			md "temp\frame_tmp"
		)

		"ffmpeg\bin\ffmpeg.exe" -i "video\%%B" -qscale:v 1 -qmin 1 -qmax 1 -vsync 0 "temp\video_tmp\frame%%08d.png"

		"realesrgan-ncnn-vulkan.exe" -i temp\video_tmp -o temp\frame_tmp -n realesr-animevideov3 -s 2 -f jpg

		del /S /Q "temp\video_tmp" > nul

		if exist "video_enc" (
			echo "video_enc exist : OK"
		) else (
			echo "ディレクトリ [video_enc] が存在しないため、該当ディレクトリを作成します。"
			md "video_enc"
		)

		for /F "delims=" %%D in ('ffmpeg\bin\ffprobe.exe -i video\%%B -v 0 -of csv^="p=0" -select_streams V:0 -show_entries stream^=r_frame_rate 2^>^&1') do (
			for /F "delims=" %%G in ('PowerShell -command "[Math]::Round(%%D, 2,[MidpointRounding]::AwayFromZero);"') do (
				"ffmpeg\bin\ffmpeg.exe" -r %%G -i "temp\frame_tmp\frame%%08d.jpg" -i "video\%%B" -map 0:v:0 -map 1:a:0 -c:a copy -c:v libx264 -r %%G -pix_fmt yuv420p "video_enc\%%B"
			)
		)

		del /S /Q "temp\frame_tmp" > nul
	)
	del /S /Q "video" > nul

) else (
	echo "ディレクトリ [video] が存在しないため、該当ディレクトリを作成します。"
	echo "ディレクトリ [video] に処理したいファイルをコピーして再度実行してください。"
	md "video"
)

pause