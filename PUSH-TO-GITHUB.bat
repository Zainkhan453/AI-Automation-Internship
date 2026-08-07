@echo off
REM ===================================================================
REM  Day-03 submission - push to GitHub
REM  Run this by double-clicking it, or from CMD in this folder.
REM ===================================================================

set /p USERNAME="Enter your GitHub username: "

echo.
echo [1/4] Replacing YOUR_GITHUB_USERNAME placeholders...
powershell -Command "Get-ChildItem -Path . -Include *.txt,*.md -Recurse | ForEach-Object { (Get-Content $_.FullName -Raw) -replace 'YOUR_GITHUB_USERNAME', '%USERNAME%' | Set-Content $_.FullName -NoNewline }"

echo [2/4] Initialising git...
git init
git branch -M main
git remote remove origin 2>nul
git remote add origin https://github.com/%USERNAME%/AI-Automation-Internship.git

echo [3/4] Committing...
git add .
git commit -m "Day 3: Git & GitHub, API fundamentals, Postman collection, n8n Lead Management API, open-source workflow audit"

echo [4/4] Pushing...
git push -u origin main --force

echo.
echo ===================================================================
echo  Done. Open: https://github.com/%USERNAME%/AI-Automation-Internship
echo ===================================================================
pause
