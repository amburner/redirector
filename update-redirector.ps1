$repoPath = "C:\Users\Ash\Desktop\Background\desktop\redirector"
$ngrokJsonPath = Join-Path $repoPath "ngrok.json"
$indexHtmlPath = Join-Path $repoPath "index.html"

$ngrokData = Get-Content $ngrokJsonPath | ConvertFrom-Json
$url = $ngrokData.url

if (-not $url) {
    Write-Error "❌ No URL found in ngrok.json."
    exit 1
}

$html = @"
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv='refresh' content='0; url=$url'>
    <title>Redirecting...</title>
  </head>
  <body style='background:black;color:white;'>
    Redirecting to <a href='$url'>$url</a>...
  </body>
</html>
"@

$html | Set-Content -Encoding UTF8 $indexHtmlPath

Set-Location $repoPath
git add index.html ngrok.json
git commit -m "Auto-update redirect to $url"
git push origin main

Write-Host "🚀 GitHub redirector updated and pushed."
