# PowerShell script to convert PNG images to WebP format
# This will significantly reduce file sizes and improve scrolling performance

$sourceFolder = "Apple vision canvas images"
$outputFolder = "Apple vision canvas images webp"

# Create output folder if it doesn't exist
if (-not (Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
    Write-Host "Created output folder: $outputFolder" -ForegroundColor Green
}

# Get all PNG files
$pngFiles = Get-ChildItem -Path $sourceFolder -Filter "*.png"

Write-Host "`nConverting $($pngFiles.Count) PNG files to WebP format..." -ForegroundColor Cyan
Write-Host "This requires ImageMagick or an online converter.`n" -ForegroundColor Yellow

# Check if ImageMagick is installed
$magickInstalled = Get-Command magick -ErrorAction SilentlyContinue

if ($magickInstalled) {
    Write-Host "ImageMagick found! Converting images..." -ForegroundColor Green
    
    foreach ($file in $pngFiles) {
        $outputFile = Join-Path $outputFolder ($file.BaseName + ".webp")
        $inputFile = $file.FullName
        
        # Convert with 85% quality (good balance between size and quality)
        magick convert "$inputFile" -quality 85 "$outputFile"
        
        $originalSize = [math]::Round($file.Length / 1KB, 2)
        $newSize = [math]::Round((Get-Item $outputFile).Length / 1KB, 2)
        $savings = [math]::Round((1 - ($newSize / $originalSize)) * 100, 1)
        
        Write-Host "Converted: $($file.Name) -> $($file.BaseName).webp | $originalSize KB -> $newSize KB ($savings% smaller)" -ForegroundColor Green
    }
    
    Write-Host "`n✅ Conversion complete! WebP files saved to: $outputFolder" -ForegroundColor Green
}
else {
    Write-Host "❌ ImageMagick not found!" -ForegroundColor Red
    Write-Host "`nTo install ImageMagick:" -ForegroundColor Yellow
    Write-Host "1. Using Chocolatey: choco install imagemagick" -ForegroundColor White
    Write-Host "2. Using Scoop: scoop install imagemagick" -ForegroundColor White
    Write-Host "3. Download from: https://imagemagick.org/script/download.php#windows`n" -ForegroundColor White
    
    Write-Host "Alternative: Use an online converter like:" -ForegroundColor Yellow
    Write-Host "- https://cloudconvert.com/png-to-webp" -ForegroundColor White
    Write-Host "- https://convertio.co/png-webp/`n" -ForegroundColor White
}
