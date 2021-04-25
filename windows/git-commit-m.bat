@ECHO OFF

SET argC=0
FOR %%x IN (%*) DO SET /A argC+=1

SET minArg=1
IF %argC% LSS 1 (
  ECHO|SET /p="Usage: git-commit-m <commit message>"
  EXIT /b
)

SETLOCAL ENABLEDELAYEDEXPANSION
SET count=1
FOR /F "tokens=* USEBACKQ" %%F IN (`git status`) DO (
  SET var!count!=%%F
  SET /a count=!count!+1
)
ECHO %var1%

for /F "tokens=3 delims= " %%a in ("%var1%") do (
  for /F "tokens=1 delims=-" %%b in ("%%a") do (
     set pt1=%%b
  )
  for /F "tokens=2 delims=-" %%b in ("%%a") do (
     set pt2=%%b
  )
)

git commit -m "%pt1%-%pt2% %1"
