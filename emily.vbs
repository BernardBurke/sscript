option explicit

dim i,j
dim istr,jstr

'const emily="https://content6.erosberry.com/theemilybloom.com/"
const emily="https://content6.erosberry.com/watch4beauty.com/"




Function PadDigits(val, digits)
  PadDigits = Right(String(digits,"0") & val, digits)
End Function

for i = 1 to 9999
    istr = PadDigits(i,4)
    for j = 1 to 20
        jstr = PadDigits(j,2)
        wscript.echo emily &  istr & "/" & jstr & ".jpg"
    next
next