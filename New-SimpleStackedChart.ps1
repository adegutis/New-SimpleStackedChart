
Function New-SimpleStackedChart {
    <#
    .SYNOPSIS
        Creates a simple stacked chart that uses color coding and text
    .DESCRIPTION
        Creates a simple stacked chart that uses color coding and text to summary a status or metric
    .EXAMPLE
        PS C:\> New-SimpleStackedChart -data $CpuData -OutputFile '.\chart1.png' -Verbose -BackgroundColor black -TextColor white -Title 'CPU Summary' -FontSize 11
        Creates a graphic file with the data from $CpuData using a black background, white text, the title 'CPU Summary' and 11pt font
    .PARAMETER Data
        Required - an array of data which must include the following: Text, TextColor, BackgroundColor
    .PARAMETER OutputFile
        Required - the output file [string]
    .PARAMETER TotalHeight
        the height of the chart graphic [int]
    .PARAMETER TotalWidth
        the width of the chart graphic [int]
    .PARAMETER FontName
        the font to use [string]
    .PARAMETER FontSize
        the font size [int]
    .PARAMETER Title
        the title at the top of the graphic [string]
    .PARAMETER BackgroundColor
        the background color [string]
    .PARAMETER TextColor
        the color of the text on the graphic [string]
    .INPUTS
    
    .OUTPUTS
        Graphic image file of the chart
    .NOTES
        Data must be an array with the following fields: Text, TextColor, BackgroundColor
    
        Example:

            Text  TextColor BackgroundColor
            ----  --------- ---------------
            Test1 White     Red            
            Test2 Black     Yellow         
            Test3 Black     LightGreen     
            Test4 White     Green  


            $InputData = [pscustomobject] @{
                Text  = ''
                TextColor = ''
                BackgroundColor = ''
            }
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)][array]$Data,
        [Parameter(Mandatory = $True)][string]$OutputFile,
        [Parameter(Mandatory = $False)][int]$TotalHeight = 200,
        [Parameter(Mandatory = $False)][int]$TotalWidth = 250,
        [Parameter(Mandatory = $False)][string]$FontName = 'Consolas',
        [Parameter(Mandatory = $False)][int]$FontSize = 12,
        [Parameter(Mandatory = $False)][string]$Title,
        [Parameter(Mandatory = $False)][string]$BackgroundColor = 'White',
        [Parameter(Mandatory = $False)][string]$TextColor = 'Black'
    )

    $NumberOfSections = $Data.count

    $bmp = new-object System.Drawing.Bitmap $TotalWidth, $TotalHeight 
    $font = new-object System.Drawing.Font $FontName, ($FontSize + 2) 
    $graphics = [System.Drawing.Graphics]::FromImage($bmp) 
    
    # Title Section
    $brushBg = [System.Drawing.Brushes]::$BackgroundColor
    $brushFg = [System.Drawing.Brushes]::$TextColor
    $x = 0; 
    $y = 0; 
    $width = $TotalWidth; 
    $height = $TotalHeight / [int]($NumberOfSections + 1)
    $graphics.FillRectangle($brushBg, $x, $y, $width, $height) 
    $graphics.DrawString($Title, $font, $brushFg, $x + 5, $y + ($height / $NumberOfSections))
    $font = new-object System.Drawing.Font $FontName, ($FontSize) 
    for ($i = 1 ; $i -le $NumberOfSections; $i++) {

        if ($Data[$i].BackgroundColor -ne '') {
            $brushBg = [System.Drawing.Brushes]::$($Data[$i - 1].BackgroundColor)
        } else {
            $brushBg = [System.Drawing.Brushes]::$BackgroundColor
        }
        if ($Data[$i].TextColor -ne '') {
            $brushFg = [System.Drawing.Brushes]::$($Data[$i - 1].TextColor)
        } else {
            $brushFg = [System.Drawing.Brushes]::$TextColor
        }
        $graphics.FillRectangle($brushBg, $x, $height * $i, $width, $height) 
        $graphics.DrawString($($Data[$i - 1].Text), $font, $brushFg, $x + 5, $Height * $i + ($y + ($height / $NumberOfSections)))
    }

    $graphics.Dispose() 
    $bmp.Save($OutputFile)  
}
