@echo off
cd "%~dp0"

if exist "input" (
	if exist "output" (
		echo "directory exist : OK"
	) else (
		echo "�f�B���N�g�� [output] �����݂��Ȃ����߁A�Y���f�B���N�g�����쐬���܂��B"
		md "output"
	)

	for /F "delims=" %%A in ('dir /b input') do (
		echo "%%A"
		"realesrgan-ncnn-vulkan.exe" -i "input\%%A" -o "output\%%A" -n realesrgan-x4plus-anime -s 4
	)

) else (
	echo "�f�B���N�g�� [input] �����݂��Ȃ����߁A�Y���f�B���N�g�����쐬���܂��B"
	echo "�f�B���N�g�� [input] �ɏ����������t�@�C�����R�s�[���čēx���s���Ă��������B"
	md "input"
)