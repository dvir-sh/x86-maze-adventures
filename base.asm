IDEAL
MODEL small
STACK 100h
p386
DATASEG
Clock equ es:6Ch
filename db 'screen1.bmp',0
filehandle dw ?
filenamemap db "map.txt",0
filehandle2 dw ?
Header db 54 dup (0)
Palette db 256*4 dup (0)
ScrLine db 320 dup (0)
ErrorMsg db 'Error', 13, 10 ,'$'
delaytimeval dw ?
color db ?
x dw 9
y dw ?
linex dw ?
liney dw ?
linemaxx dw ?
linemaxy dw ?
linevoidx dw 0
level db 1
voidspeed dw 20
voidspeedk dw 250
starx dw ?
stary dw ?
sstarx dw ?
sstary dw ?
bombx dw ?
bomby dw ?
savexforstar dw ?
saveyforstar dw ?
starcount db 0
forstarloop db ?
gotstar dw 0
staramountx dw ?
heartamountx dw ?
heartcount db 5
peaceful db 0
firsttimeinlevel db 1
noteC4 dw 4560  
noteE4 dw 3620 
noteG4 dw 3041
note dw 6000
noteA4 dw 2712 
noteC5 dw 2284 
noteE5 dw 1809 
noteG5 dw 1522 
noteC6 dw 1141 
noteB4 dw 2417 
noteD5 dw 2031 
noteG3 dw 6085  
noteDSharp4 dw 3835  
noteFSharp4 dw 3224  
noteD4 dw 4069  
noteA3 dw 5424  
start_ticks dw 0
countforbomb dw 50
countforbombexp dw 0
countforendexp dw 0
bombarry dw 4 dup (?)
bombarrx dw 4 dup (?)
currentbomb dw 0
deleteordraw dw 0
bombsonoroff dw 0
keyboardormouse dw 0
xk dw 0
yk dw 0
mousexspeed dw 128
mouseyspeed dw 256
moveupk db 11h
moveleftk db 1eh
movedownk db 1fh
moverightk db 20h
xscreator dw 150 dup (0)
yscreator dw 150 dup (0)
xmaxcreator dw 150 dup (0)
ymaxcreator dw 150 dup (0)
linescolor db 0
backroundcolor db 100
bordercolor db 0
bordersize dw 3
playerxposc dw 10
playeryposc dw 100
starxposc dw 500
staryposc dw 500
mapinfo dw 8 dup (0) 
xstartedc dw 0
ystartedc dw 0
xcurrentc dw 0
ycurrentc dw 0
xprivc dw 0
yprivc dw 0
currentline dw 10
savecolor db 0
savecolorarr db 150 dup (0)
normalorcrated db 0
lastcolor db 0
whichscreen db 0
currentlevelc dw 0
maxlevel db 0
; --------------------------
; Your variables here
; --------------------------
CODESEG
proc restart
; close the speaker
in al, 61h
and al, 11111100b
out 61h, al
call CloseFile
mov [countforbomb], 40
mov [countforbombexp], 0
mov [countforendexp], 0
mov [note], 6000
mov [deleteordraw], 0
mov [currentbomb], 0
cmp [firsttimeinlevel], 0
je checkpeace
call levelhandler
checkpeace:
cmp [gotstar], 1
jne didntgetstar
dec [starcount]
mov [gotstar], 0
didntgetstar:	; Graphic mode
mov ax, 13h
int 10h
mov ax,0h
int 33h
mov [linevoidx], 0
call setmousesnsitivity
call setbackround
call borders
cmp [normalorcrated], 1
je crated1
cmp [level], 1
jg notlevel1
call level1
call drawstar
call resetmousepos
jmp aftercallinglevel
notlevel1:	cmp [level], 2
jg notlevel2
call level2
call drawstar
call resetmousepos
jmp aftercallinglevel
notlevel2:	cmp [level], 3
jg notlevel3
call level3
call drawstar
call resetmouseposlevel3
jmp aftercallinglevel
notlevel3:	cmp [level], 4
jg notlevel4
call level4
call drawstar
call resetmouseposlevel4
jmp aftercallinglevel
notlevel4: call level5
call drawstar
call resetmousepos
jmp aftercallinglevel
crated1: call mapcrated
call drawstar
call resetmouseposlevelc
aftercallinglevel:	
mov [firsttimeinlevel], 0
cmp [peaceful], 1
je peacefulmoder
call drawamountofhearts
peacefulmoder:
cmp [starcount], 0
je hasnostars
call drawamountofstars
hasnostars:
cmp [bombsonoroff], 1
je dontgeneratecoords
generatefirstbombcorrds:	call bombcoords
mov bx, [currentbomb]
mov dx, [bomby]
mov cx, [bombx]
mov [bombarry+bx], dx
mov [bombarrx+bx], cx
add [currentbomb], 2
cmp [currentbomb],6
jl generatefirstbombcorrds
mov [currentbomb], 0
dontgeneratecoords:
cmp [keyboardormouse], 1
je iskbrs
call mousechecking
iskbrs:
call keyboardchecking
ret
endp restart
proc bomb
proc drawbomb
mov [color], 17
cmp [linevoidx], 100
jl firstbomb
call bombcoords
mov dx, [bomby]
mov cx, [bombx]
mov bx, [currentbomb]
mov [bombarry+bx], dx
mov [bombarrx+bx], cx
firstbomb: 
mov bx, [currentbomb]
mov dx,	[bombarry+bx]
mov cx,	[bombarrx+bx]
mov [bomby], dx
mov [bombx], cx
add [currentbomb], 2
sub dx, 3
sub cx, 3
mov [liney], dx
mov [linex], cx
add dx, 7
add cx, 7
mov [linemaxy], dx
mov [linemaxx], cx
call hozline
mov dx, [bomby]
mov cx, [bombx]
sub cx, 4
dec dx
mov [liney], dx
mov [linex], cx
add dx, 3
mov [linemaxy], dx
call onepixellinever
mov dx, [bomby]
mov cx, [bombx]
add cx, 4
dec dx
mov [liney], dx
mov [linex], cx
add dx, 3
mov [linemaxy], dx
call onepixellinever
mov dx, [bomby]
mov cx, [bombx]
dec cx 
sub dx, 4
mov [liney], dx
mov [linex], cx
add cx, 3
mov [linemaxx], cx
call onepixellinehoz
mov dx, [bomby]
mov cx, [bombx]
dec cx 
add dx, 4
mov [liney], dx
mov [linex], cx
add cx, 3
mov [linemaxx], cx
call onepixellinehoz
mov dx, [bomby]
mov cx, [bombx]
mov [color], 15
mov [liney], dx
mov [linex], cx
sub dx, 5
call printdot
dec dx
call printdot
mov [color], 39
inc cx
call printdot
mov [color], 40
dec dx
call printdot
ret
endp drawbomb
proc bombcoords
mov ax, 40h
mov es, ax
callrandomyagain:	call randomcoordy
cmp [stary], 190
jg callrandomyagain
cmp [stary], 10
jl callrandomyagain
mov dx, [stary]
callrandomxagain:	call randomcoordx
cmp [starx], 310
jg callrandomxagain
cmp [starx], 10
jl callrandomxagain
mov cx, [starx]
mov [bomby], dx
mov [bombx], cx
sub [bombx], 3
sub [bomby], 3
ret
endp bombcoords
proc drawexplosion
fourthexp:	mov [color], 41
cmp [deleteordraw], 1
jne notdelete1
mov [color], 100
notdelete1:
mov bx, [currentbomb]
mov dx, [bombarry+bx]
mov cx, [bombarrx+bx]
sub dx, 11
sub cx, 11
mov [liney], dx
mov [linex], cx
add dx, 23
add cx, 23
mov [linemaxy], dx
mov [linemaxx], cx
call hozline
mov [color], 40
cmp [deleteordraw], 1
jne notdelete2
mov [color], 100
notdelete2:
mov bx, [currentbomb]
mov dx, [bombarry+bx]
mov cx, [bombarrx+bx]
sub dx, 5
sub cx, 5
mov [liney], dx
mov [linex], cx
add dx, 11
add cx, 11
mov [linemaxy], dx
mov [linemaxx], cx
call hozline
add [currentbomb], 2
cmp [currentbomb],6
jl fourthexp
cmp [keyboardormouse], 1
je iskbvoid
mov ax,3h
int 33h
jmp notkbvoid
iskbvoid:
mov cx, [xk]
mov dx, [yk]
notkbvoid:
shr cx,1
dec dx
dec cx
mov bh,0h
mov ah,0Dh
int 10h 
cmp al, 4
je lefttop2
mov [delaytimeval], 1
call delaytime
call differentcolor
lefttop2:
add dx, 2
mov bh,0h
mov ah,0Dh
int 10h 
cmp al, 4
je leftbottom2
mov [delaytimeval], 1
call delaytime
call differentcolor
leftbottom2:
add cx, 2
mov bh,0h
mov ah,0Dh
int 10h 
cmp al, 4
je rightottom2
mov [delaytimeval], 1
call delaytime
call differentcolor
rightottom2:
sub dx, 2
mov bh,0h
mov ah,0Dh
int 10h 
cmp al, 4
je righttop2
mov [delaytimeval], 1
call delaytime
call differentcolor
righttop2:
mov [currentbomb], 0
ret
endp drawexplosion
ret
endp bomb
proc linesprint
proc hozline
mov dx, [liney]
mov cx, [linex]
drawhozline:	call printdot
inc dx
cmp dx, [linemaxy]
jne drawhozline
mov dx, [liney]
inc cx
cmp cx, [linemaxx]
jne drawhozline
ret
endp hozline
proc verline
mov dx, [liney]
mov cx, [linex]
drawverline:	call printdot
inc cx
cmp cx, [linemaxx]
jne drawverline
mov cx, [linex]
inc dx
cmp dx, [linemaxy]
jne drawverline
ret
endp verline
proc onepixellinever
mov dx, [liney]
mov cx, [linex]
drawonepixelline:	call printdot
inc dx
cmp dx, [linemaxy]
jne drawonepixelline
ret
endp onepixellinever
proc onepixellinehoz
mov dx, [liney]
mov cx, [linex]
drawonepixellinehoz:	call printdot
inc cx
cmp cx, [linemaxx]
jne drawonepixellinehoz
ret
endp onepixellinehoz
ret
endp linesprint
proc resetposs
proc resetmousepos
cmp [keyboardormouse], 1
je iskbmousepos
mov ax, 4h
mov cx, 10
mov dx, 100
int 33h
iskbmousepos:	
mov [xk], 10
mov [yk], 100
ret
endp resetmousepos
proc resetmouseposlevel3
cmp [keyboardormouse], 1
je iskbmousepos2
mov ax, 4h
mov cx, 20
mov dx, 10
int 33h
iskbmousepos2:	
mov [xk], 20
mov [yk], 10
ret
endp resetmouseposlevel3
proc resetmouseposlevel4
cmp [keyboardormouse], 1
je iskbmousepos3
mov ax, 4h
mov cx, 24
mov dx, 190
int 33h
iskbmousepos3:	
mov [xk], 24
mov [yk], 190
ret
endp resetmouseposlevel4
proc resetmouseposlevelc
cmp [keyboardormouse], 1
mov cx, [playerxposc]
mov dx, [playeryposc]
je iskbmousepos4
mov ax, 4h
mov cx, [playerxposc]
mov dx, [playeryposc]
shl cx, 1
int 33h
iskbmousepos4:	
shl cx, 1
mov [xk], cx
mov [yk], dx
ret
endp resetmouseposlevelc
proc resetsavedpos
mov ax, 4h
mov cx, [savexforstar]
mov dx, [saveyforstar]
int 33h
ret
ret
endp resetsavedpos
ret
endp resetposs
proc levelssetteranddrawer
proc level1
mov al, 0
mov [color], al
mov [liney], 108
mov [linex], 3
mov [linemaxy], 111
mov [linemaxx], 60
call hozline
mov [liney], 108
mov [linex], 60
mov [linemaxy], 130
mov [linemaxx], 63
call verline
mov [liney], 150
mov [linex], 60
mov [linemaxy], 200
mov [linemaxx], 63
call verline
mov [liney], 108
mov [linex], 79
mov [linemaxy], 180
mov [linemaxx], 82
call verline
mov [liney], 177
mov [linex], 82
mov [linemaxy], 180
mov [linemaxx], 200
call hozline
mov [liney], 177
mov [linex], 200
mov [linemaxy], 200
mov [linemaxx], 203
call verline
mov [liney], 89
mov [linex], 3
mov [linemaxy], 92
mov [linemaxx], 60
call hozline
mov [liney], 0
mov [linex], 60
mov [linemaxy], 40
mov [linemaxx], 63
call verline
mov [liney], 60
mov [linex], 60
mov [linemaxy], 92
mov [linemaxx], 63
call verline
mov [liney], 21
mov [linex], 79
mov [linemaxy], 40
mov [linemaxx], 82
call verline
mov [liney], 60
mov [linex], 79
mov [linemaxy], 92
mov [linemaxx], 82
call verline
mov [liney], 21
mov [linex], 82
mov [linemaxy], 24
mov [linemaxx], 297
call hozline
mov [liney], 108
mov [linex], 82
mov [linemaxy], 111
mov [linemaxx], 150
call hozline
mov [liney], 108
mov [linex], 170
mov [linemaxy], 111
mov [linemaxx], 297
call hozline
mov [liney], 89
mov [linex], 82
mov [linemaxy], 92
mov [linemaxx], 297
call hozline
mov [liney], 23
mov [linex], 294
mov [linemaxy], 200
mov [linemaxx], 297
call verline

;all the decordative lines
mov [liney], 3
mov [linex], 35
mov [linemaxy], 50
mov [linemaxx], 38
call verline
mov [liney], 70
mov [linex], 34
mov [linemaxy], 73
mov [linemaxx], 60
call hozline
mov [liney], 140
mov [linex], 82
mov [linemaxy], 143
mov [linemaxx], 160
call hozline
mov [liney], 111
mov [linex], 20
mov [linemaxy], 180
mov [linemaxx], 23
call verline
call hozline
mov [liney], 111
mov [linex], 240
mov [linemaxy], 182
mov [linemaxx], 243
call verline
mov [liney], 55
mov [linex], 167
mov [linemaxy], 91
mov [linemaxx], 170
call verline

;finish
mov al, 117
mov [color], al
mov [liney], 170
mov [linex], 297
mov [linemaxy], 197
mov [linemaxx], 317
call verline

ret
endp level1
proc level2
mov al, 0
mov [color], al
mov [liney], 89
mov [linex], 3
mov [linemaxy], 92
mov [linemaxx], 60
call hozline
mov [liney], 21
mov [linex], 79
mov [linemaxy], 92
mov [linemaxx], 82
call verline
mov [liney], 0
mov [linex], 60
mov [linemaxy], 40
mov [linemaxx], 63
call verline
mov [liney], 60
mov [linex], 60
mov [linemaxy], 92
mov [linemaxx], 63
call verline
mov [liney], 21
mov [linex], 82
mov [linemaxy], 24
mov [linemaxx], 200
call hozline
mov [liney], 108
mov [linex], 3
mov [linemaxy], 111
mov [linemaxx], 30
call hozline
mov [liney], 108
mov [linex], 27
mov [linemaxy], 120
mov [linemaxx], 30
call verline
mov [liney], 108
mov [linex], 46
mov [linemaxy], 120
mov [linemaxx], 49
call verline
mov [liney], 136
mov [linex], 27
mov [linemaxy], 180
mov [linemaxx], 30
call verline
mov [liney], 136
mov [linex], 46
mov [linemaxy], 180
mov [linemaxx], 49
call verline
mov [liney], 177
mov [linex], 30
mov [linemaxy], 180
mov [linemaxx], 220
call hozline
mov [liney], 21
mov [linex], 217
mov [linemaxy], 180
mov [linemaxx], 220
call verline
mov [liney], 21
mov [linex], 237
mov [linemaxy], 70
mov [linemaxx], 240
call verline
mov [liney], 87
mov [linex], 237
mov [linemaxy], 180
mov [linemaxx], 240
call verline
mov [liney], 67
mov [linex], 220
mov [linemaxy], 70
mov [linemaxx], 237
call hozline
mov [liney], 21
mov [linex], 240
mov [linemaxy], 24
mov [linemaxx], 270
call hozline
mov [liney], 87
mov [linex], 240
mov [linemaxy], 90
mov [linemaxx], 289
call hozline
mov [liney], 21
mov [linex], 286
mov [linemaxy], 200
mov [linemaxx], 289
call verline
mov [liney], 0
mov [linex], 267
mov [linemaxy], 70
mov [linemaxx], 270
call verline
mov [liney], 177
mov [linex], 240
mov [linemaxy], 180
mov [linemaxx], 263
call hozline
mov [liney], 120
mov [linex], 260
mov [linemaxy], 177
mov [linemaxx], 263
call verline
mov [liney], 108
mov [linex], 46
mov [linemaxy], 111
mov [linemaxx], 140
call hozline
mov [liney], 117
mov [linex], 46
mov [linemaxy], 120
mov [linemaxx], 66
call hozline
mov [liney], 117
mov [linex], 66
mov [linemaxy], 167
mov [linemaxx], 69
call verline
mov [liney], 164
mov [linex], 69
mov [linemaxy], 167
mov [linemaxx], 200
call hozline
mov [liney], 130
mov [linex], 200
mov [linemaxy], 133
mov [linemaxx], 217
call hozline
mov [liney], 23
mov [linex], 197
mov [linemaxy], 164
mov [linemaxx], 200
call verline
mov [liney], 60
mov [linex], 137
mov [linemaxy], 111
mov [linemaxx], 140
call verline
mov [liney], 57
mov [linex], 110
mov [linemaxy], 60
mov [linemaxx], 140
call hozline
mov [liney], 40
mov [linex], 110
mov [linemaxy], 60
mov [linemaxx], 113
call verline
mov [liney], 40
mov [linex], 113
mov [linemaxy], 43
mov [linemaxx], 175
call hozline
mov [liney], 40
mov [linex], 172
mov [linemaxy], 145
mov [linemaxx], 175
call verline
mov [liney], 142
mov [linex], 95
mov [linemaxy], 145
mov [linemaxx], 172
call hozline
mov [liney], 125
mov [linex], 95
mov [linemaxy], 142
mov [linemaxx], 98
call verline
mov [liney], 122
mov [linex], 95
mov [linemaxy], 125
mov [linemaxx], 150
call hozline
mov [liney], 89
mov [linex], 82
mov [linemaxy], 92
mov [linemaxx], 110
call hozline

;all the decordative lines
mov [liney], 3
mov [linex], 35
mov [linemaxy], 50
mov [linemaxx], 38
call verline
mov [liney], 40
mov [linex], 15
mov [linemaxy], 89
mov [linemaxx], 18
call verline
mov [liney], 80
mov [linex], 40
mov [linemaxy], 83
mov [linemaxx], 60
call hozline

;finish
mov al, 117
mov [color], al
mov [liney], 170
mov [linex], 289
mov [linemaxy], 197
mov [linemaxx], 317
call verline
ret
endp level2
proc level3
mov al, 0
mov [color], al
mov [liney], 3
mov [linex], 20
mov [linemaxy], 50
mov [linemaxx], 23
call verline
mov [liney], 108
mov [linex], 3
mov [linemaxy], 111
mov [linemaxx], 30
call hozline
mov [liney], 25
mov [linex], 60
mov [linemaxy], 28
mov [linemaxx], 200
call hozline
mov [liney], 28
mov [linex], 60
mov [linemaxy], 88
mov [linemaxx], 63
call verline
mov [liney], 28
mov [linex], 80
mov [linemaxy], 88
mov [linemaxx], 83
call verline
mov [liney], 50
mov [linex], 40
mov [linemaxy], 53
mov [linemaxx], 60
call hozline
mov [liney], 85
mov [linex], 83
mov [linemaxy], 88
mov [linemaxx], 110
call hozline
mov [liney], 45
mov [linex], 107
mov [linemaxy], 64
mov [linemaxx], 110
call verline
mov [liney], 42
mov [linex], 107
mov [linemaxy], 45
mov [linemaxx], 180
call hozline
mov [liney], 61
mov [linex], 107
mov [linemaxy], 64
mov [linemaxx], 150
call hozline
mov [liney], 64
mov [linex], 147
mov [linemaxy], 108
mov [linemaxx], 150
call verline
mov [liney], 85
mov [linex], 135
mov [linemaxy], 88
mov [linemaxx], 150
call hozline
mov [liney], 25
mov [linex], 40
mov [linemaxy], 88
mov [linemaxx], 43
call verline
mov [liney], 72
mov [linex], 20
mov [linemaxy], 75
mov [linemaxx], 40
call hozline
mov [liney], 111
mov [linex], 27
mov [linemaxy], 120
mov [linemaxx], 30
call verline
mov [liney], 137
mov [linex], 27
mov [linemaxy], 180
mov [linemaxx], 30
call verline
mov [liney], 177
mov [linex], 30
mov [linemaxy], 180
mov [linemaxx], 130
call hozline
mov [liney], 180
mov [linex], 127
mov [linemaxy], 197
mov [linemaxx], 130
call verline
mov [liney], 108
mov [linex], 47
mov [linemaxy], 120
mov [linemaxx], 50
call verline
mov [liney], 137
mov [linex], 47
mov [linemaxy], 140
mov [linemaxx], 70
call hozline
mov [liney], 140
mov [linex], 47
mov [linemaxy], 167
mov [linemaxx], 50
call verline
mov [liney], 164
mov [linex], 50
mov [linemaxy], 167
mov [linemaxx], 200
call hozline
mov [liney], 137
mov [linex], 197
mov [linemaxy], 167
mov [linemaxx], 200
call verline
mov [liney], 28
mov [linex], 197
mov [linemaxy], 120
mov [linemaxx], 200
call verline
mov [liney], 25
mov [linex], 239
mov [linemaxy], 28
mov [linemaxx], 265
call hozline
mov [liney], 3
mov [linex], 218
mov [linemaxy], 67
mov [linemaxx], 221
call verline
mov [liney], 43
mov [linex], 239
mov [linemaxy], 67
mov [linemaxx], 242
call verline
mov [liney], 20
mov [linex], 288
mov [linemaxy], 46
mov [linemaxx], 291
call verline
mov [liney], 67
mov [linex], 288
mov [linemaxy], 145
mov [linemaxx], 291
call verline
mov [liney], 108
mov [linex], 50
mov [linemaxy], 111
mov [linemaxx], 150
call hozline
mov [liney], 117
mov [linex], 50
mov [linemaxy], 120
mov [linemaxx], 197
call hozline
mov [liney], 67
mov [linex], 200
mov [linemaxy], 70
mov [linemaxx], 221
call hozline
mov [liney], 67
mov [linex], 239
mov [linemaxy], 70
mov [linemaxx], 265
call hozline
mov [liney], 3
mov [linex], 265
mov [linemaxy], 28
mov [linemaxx], 268
call verline
mov [liney], 43
mov [linex], 265
mov [linemaxy], 70
mov [linemaxx], 268
call verline
mov [liney], 43
mov [linex], 239
mov [linemaxy], 46
mov [linemaxx], 317
call hozline
mov [liney], 85
mov [linex], 218
mov [linemaxy], 180
mov [linemaxx], 221
call verline
mov [liney], 177
mov [linex], 147
mov [linemaxy], 180
mov [linemaxx], 218
call hozline
mov [liney], 137
mov [linex], 90
mov [linemaxy], 140 
mov [linemaxx], 180
call hozline
mov [liney], 120
mov [linex], 170
mov [linemaxy], 137
mov [linemaxx], 173
call verline
mov [liney], 167
mov [linex], 182
mov [linemaxy], 180
mov [linemaxx], 185
call verline
mov [liney], 153
mov [linex], 160
mov [linemaxy], 167
mov [linemaxx], 163
call verline
mov [liney], 137
mov [linex], 125
mov [linemaxy], 150
mov [linemaxx], 128
call verline
mov [liney], 85
mov [linex], 239
mov [linemaxy], 88 
mov [linemaxx], 288
call hozline
mov [liney], 140
mov [linex], 239
mov [linemaxy], 180
mov [linemaxx], 242
call verline
mov [liney], 150
mov [linex], 220
mov [linemaxy], 153
mov [linemaxx], 239
call hozline
mov [liney], 177
mov [linex], 242
mov [linemaxy], 180
mov [linemaxx], 291
call hozline
mov [liney], 180
mov [linex], 288
mov [linemaxy], 197
mov [linemaxx], 291
call verline
mov [liney], 88
mov [linex], 239
mov [linemaxy], 120
mov [linemaxx], 242
call verline
mov [liney], 123
mov [linex], 267
mov [linemaxy], 126
mov [linemaxx], 288
call hozline
mov [liney], 103
mov [linex], 264
mov [linemaxy], 162
mov [linemaxx], 267
call verline

;finish
mov al, 117
mov [color], al
mov [liney], 3
mov [linex], 291
mov [linemaxy], 43
mov [linemaxx], 317
call verline
ret
endp level3
proc level4
mov [liney], 177
mov [linex], 20
mov [linemaxy], 180
mov [linemaxx], 130
call hozline ;1
mov [liney], 70
mov [linex], 20
mov [linemaxy], 155
mov [linemaxx], 23
call verline ;2
mov [liney], 3
mov [linex], 40
mov [linemaxy], 100
mov [linemaxx], 43
call verline ;3
mov [liney], 20
mov [linex], 20
mov [linemaxy], 50
mov [linemaxx], 23
call verline ;4
mov [liney], 20
mov [linex], 23
mov [linemaxy], 23
mov [linemaxx], 40
call hozline ;5
mov [liney], 117
mov [linex], 40
mov [linemaxy], 163
mov [linemaxx], 43
call verline ;6
mov [liney], 50
mov [linex], 60
mov [linemaxy], 100
mov [linemaxx], 63
call verline ;7
mov [liney], 160
mov [linex], 43
mov [linemaxy], 163
mov [linemaxx], 145
call hozline ;8
mov [liney], 177
mov [linex], 147
mov [linemaxy], 180
mov [linemaxx], 220
call hozline ;9
mov [liney], 160
mov [linex], 162
mov [linemaxy], 163
mov [linemaxx], 200
call hozline ;10
mov [liney], 138
mov [linex], 60
mov [linemaxy], 141
mov [linemaxx], 200
call hozline ;11
mov [liney], 141
mov [linex], 197
mov [linemaxy], 160
mov [linemaxx], 200
call verline ;12
mov [liney], 85
mov [linex], 217
mov [linemaxy], 180
mov [linemaxx], 220
call verline ;13
mov [liney], 117
mov [linex], 142
mov [linemaxy], 141
mov [linemaxx], 145
call verline ;14
mov [liney], 117
mov [linex], 162
mov [linemaxy], 141
mov [linemaxx], 165
call verline ;15
mov [liney], 117
mov [linex], 43
mov [linemaxy], 120
mov [linemaxx], 142
call hozline ;16
mov [liney], 117
mov [linex], 165
mov [linemaxy], 120
mov [linemaxx], 200
call hozline ;17
mov [liney], 74
mov [linex], 63
mov [linemaxy], 77
mov [linemaxx], 84
call hozline ;18
mov [liney], 77
mov [linex], 81
mov [linemaxy], 117
mov [linemaxx], 84
call verline ;19
mov [liney], 93
mov [linex], 104
mov [linemaxy], 96
mov [linemaxx], 175
call hozline ;20
mov [liney], 74
mov [linex], 104
mov [linemaxy], 96
mov [linemaxx], 107
call verline ;21
mov [liney], 74
mov [linex], 104
mov [linemaxy], 77
mov [linemaxx], 150
call hozline ;22
mov [liney], 50
mov [linex], 172
mov [linemaxy], 93
mov [linemaxx], 175
call verline ;23
mov [liney], 26
mov [linex], 81
mov [linemaxy], 53
mov [linemaxx], 84
call verline ;24
mov [liney], 50
mov [linex], 84
mov [linemaxy], 53
mov [linemaxx], 172
call hozline ;25
mov [liney], 26
mov [linex], 60
mov [linemaxy], 29
mov [linemaxx], 120
call hozline ;26
mov [liney], 3
mov [linex], 117
mov [linemaxy], 26
mov [linemaxx], 120
call verline ;27
mov [liney], 65
mov [linex], 197
mov [linemaxy], 120
mov [linemaxx], 200
call verline ;28
mov [liney], 26
mov [linex], 197
mov [linemaxy], 48
mov [linemaxx], 200
call verline ;29
mov [liney], 26
mov [linex], 137
mov [linemaxy], 29
mov [linemaxx], 197
call hozline ;30
mov [liney], 97
mov [linex], 200
mov [linemaxy], 100
mov [linemaxx], 217
call hozline ;31
mov [liney], 65
mov [linex], 200
mov [linemaxy], 68
mov [linemaxx], 270
call hozline ;32
mov [liney], 45
mov [linex], 200
mov [linemaxy], 48
mov [linemaxx], 270
call hozline ;33
mov [liney], 48
mov [linex], 267
mov [linemaxy], 65
mov [linemaxx], 270
call verline ;34
mov [liney], 26
mov [linex], 214
mov [linemaxy], 29
mov [linemaxx], 291
call hozline ;35
mov [liney], 150
mov [linex], 220
mov [linemaxy], 153
mov [linemaxx], 237
call hozline ;36
mov [liney], 150
mov [linex], 237
mov [linemaxy], 180
mov [linemaxx], 240
call verline ;37
mov [liney], 177
mov [linex], 240
mov [linemaxy], 180
mov [linemaxx], 267
call hozline ;38
mov [liney], 180
mov [linex], 264
mov [linemaxy], 197
mov [linemaxx], 267
call verline ;39
mov [liney], 85
mov [linex], 237
mov [linemaxy], 133
mov [linemaxx], 240
call verline ;40
mov [liney], 85
mov [linex], 240
mov [linemaxy], 88
mov [linemaxx], 291
call hozline ;41
mov [liney], 29
mov [linex], 288
mov [linemaxy], 85
mov [linemaxx], 291
call verline ;42
mov [liney], 70
mov [linex], 291
mov [linemaxy], 73
mov [linemaxx], 317
call hozline ;43
mov [liney], 105
mov [linex], 264
mov [linemaxy], 160
mov [linemaxx], 267
call verline ;44
mov [liney], 105
mov [linex], 264
mov [linemaxy], 160
mov [linemaxx], 267
call verline ;45
mov [liney], 105
mov [linex], 288
mov [linemaxy], 197
mov [linemaxx], 291
call verline ;46
mov [liney], 105
mov [linex], 267
mov [linemaxy], 108
mov [linemaxx], 288
call hozline ;47

;finish
mov al, 117
mov [color], al
mov [liney], 157
mov [linex], 291
mov [linemaxy], 197
mov [linemaxx], 317
call verline
ret
endp level4
proc level5
mov [liney], 177
mov [linex], 20
mov [linemaxy], 180
mov [linemaxx], 130
call hozline ;1
mov [liney], 70
mov [linex], 20
mov [linemaxy], 155
mov [linemaxx], 23
call verline ;2
mov [liney], 3
mov [linex], 40
mov [linemaxy], 50
mov [linemaxx], 43
call verline ;3
mov [liney], 20
mov [linex], 20
mov [linemaxy], 50
mov [linemaxx], 23
call verline ;4
mov [liney], 20
mov [linex], 23
mov [linemaxy], 23
mov [linemaxx], 40
call hozline ;5
mov [liney], 117
mov [linex], 40
mov [linemaxy], 163
mov [linemaxx], 43
call verline ;6
mov [liney], 70
mov [linex], 20
mov [linemaxy], 73
mov [linemaxx], 90
call verline ;7
mov [liney], 160
mov [linex], 43
mov [linemaxy], 163
mov [linemaxx], 145
call hozline ;8
mov [liney], 177
mov [linex], 147
mov [linemaxy], 180
mov [linemaxx], 220
call hozline ;9
mov [liney], 160
mov [linex], 162
mov [linemaxy], 163
mov [linemaxx], 200
call hozline ;10
mov [liney], 138
mov [linex], 60
mov [linemaxy], 141
mov [linemaxx], 200
call hozline ;11
mov [liney], 141
mov [linex], 197
mov [linemaxy], 160
mov [linemaxx], 200
call verline ;12
mov [liney], 85
mov [linex], 217
mov [linemaxy], 180
mov [linemaxx], 220
call verline ;13
mov [liney], 47
mov [linex], 43
mov [linemaxy], 50
mov [linemaxx], 60
call hozline ;14
mov [liney], 47
mov [linex], 77
mov [linemaxy], 50
mov [linemaxx], 113
call hozline ;15
mov [liney], 117
mov [linex], 43
mov [linemaxy], 120
mov [linemaxx], 142
call hozline ;16
mov [liney], 117
mov [linex], 165
mov [linemaxy], 120
mov [linemaxx], 200
call hozline ;17
mov [liney], 29
mov [linex], 95
mov [linemaxy], 50
mov [linemaxx], 98
call verline ;18
mov [liney], 73
mov [linex], 40
mov [linemaxy], 98
mov [linemaxx], 43
call verline ;19
mov [liney], 95
mov [linex], 43
mov [linemaxy], 98
mov [linemaxx], 170
call hozline ;20
mov [liney], 50
mov [linex], 110
mov [linemaxy], 95
mov [linemaxx], 113
call verline ;21
mov [liney], 98
mov [linex], 87
mov [linemaxy], 117
mov [linemaxx], 90
call verline ;22
mov [liney], 163
mov [linex], 87
mov [linemaxy], 177
mov [linemaxx], 90
call verline ;23
mov [liney], 163
mov [linex], 190
mov [linemaxy], 177
mov [linemaxx], 193
call verline ;24
mov [liney], 29
mov [linex], 137
mov [linemaxy], 50
mov [linemaxx], 140
call verline ;25
mov [liney], 26
mov [linex], 60
mov [linemaxy], 29
mov [linemaxx], 120
call hozline ;26
mov [liney], 47
mov [linex], 140
mov [linemaxy], 50
mov [linemaxx], 173
call hozline ;27
mov [liney], 3
mov [linex], 197
mov [linemaxy], 117
mov [linemaxx], 200
call verline ;28
mov [liney], 74
mov [linex], 130
mov [linemaxy], 77
mov [linemaxx], 197
call hozline ;29
mov [liney], 26
mov [linex], 137
mov [linemaxy], 29
mov [linemaxx], 197
call hozline ;30
mov [liney], 97
mov [linex], 200
mov [linemaxy], 100
mov [linemaxx], 217
call hozline ;31
mov [liney], 29
mov [linex], 217
mov [linemaxy], 68
mov [linemaxx], 220
call verline ;32
mov [liney], 29
mov [linex], 288
mov [linemaxy], 85
mov [linemaxx], 291
call verline ;33
mov [liney], 85
mov [linex], 237
mov [linemaxy], 133
mov [linemaxx], 240
call verline ;34
mov [liney], 26
mov [linex], 217
mov [linemaxy], 29
mov [linemaxx], 291
call hozline ;35
mov [liney], 49
mov [linex], 237
mov [linemaxy], 68
mov [linemaxx], 240
call verline ;36
mov [liney], 150
mov [linex], 237
mov [linemaxy], 180
mov [linemaxx], 240
call verline ;37
mov [liney], 177
mov [linex], 240
mov [linemaxy], 180
mov [linemaxx], 267
call hozline ;38
mov [liney], 82
mov [linex], 237
mov [linemaxy], 85
mov [linemaxx], 288
call hozline ;39
mov [liney], 49
mov [linex], 237
mov [linemaxy], 52
mov [linemaxx], 288
call hozline ;40
mov [liney], 105
mov [linex], 264
mov [linemaxy], 180
mov [linemaxx], 267
call verline ;41
mov [liney], 65
mov [linex], 260
mov [linemaxy], 68
mov [linemaxx], 288
call hozline ;42
mov [liney], 49
mov [linex], 291
mov [linemaxy], 52
mov [linemaxx], 317
call hozline ;43
mov [liney], 105
mov [linex], 291
mov [linemaxy], 108
mov [linemaxx], 317
call hozline ;44
mov [liney], 105
mov [linex], 288
mov [linemaxy], 180
mov [linemaxx], 291
call verline ;45
mov [liney], 180
mov [linex], 105
mov [linemaxy], 197
mov [linemaxx], 108
call verline ;46

;finish
mov al, 117
mov [color], al
mov [liney], 3
mov [linex], 291
mov [linemaxy], 49
mov [linemaxx], 317
call verline
ret
endp level5
proc mapcrated
mov al, 100
mov bl, [level]
mul bl
mov bx, ax
sub bx, 100
drawmapcrated:
mov cx, [xmaxcreator+bx]
mov dx, [ymaxcreator+bx]
cmp cx, [xscreator+bx]
jg xscreatorisfine2
ret
xscreatorisfine2:
cmp dx, [yscreator+bx]
jg yscreatorisfine2
ret
yscreatorisfine2:
mov [linemaxy], dx
mov [linemaxx], cx
mov cx, [xscreator+bx]
mov dx, [yscreator+bx]
mov [liney], dx
mov [linex], cx
mov al, [savecolorarr+bx]
mov [color], al
call hozline
add bx, 2
cmp bx, ax
jl drawmapcrated
ret
endp mapcrated
proc setbackround
mov al, [backroundcolor]
mov [color], al
mov cx, 0
mov dx, 0
drawbackround:	call printdot
inc cx
cmp cx, 320
jne drawbackround
mov cx, 0
inc dx
cmp dx, 200
jne drawbackround
ret
endp setbackround
proc borders
mov al, 0
cmp [normalorcrated], 1
jne notcrated5
mov al, [bordercolor]
notcrated5:
mov [color], al
mov [liney], 0
mov [linex], 0
mov bx, [bordersize]
mov [linemaxy], bx
mov [linemaxx], 320
call hozline
mov bx, 200
sub bx, [bordersize]
mov [liney], bx
mov [linex], 0
mov [linemaxy], 200
mov [linemaxx], 320
call hozline
mov [liney], 0
mov [linex], 0
mov bx, [bordersize]
mov [linemaxy], 200
mov [linemaxx], bx
call verline
mov bx, 320
sub bx, [bordersize]
mov [liney], 0
mov [linex], bx
mov [linemaxy], 200
mov [linemaxx], 320
call verline
ret
endp borders
ret
endp levelssetteranddrawer
proc playerdrawingandchecks
proc mousechecking
mov si, 0
mov di, 0
mov ax,3h
int 33h
shr cx,1
sub dx, 1
mov [x], cx
mov [y], dx
mov al, 4
mov [color], al
call printdot ;middeletop
dec cx
call printdot ;lefttop
inc dx 
call printdot ;left
inc dx 
call printdot;leftbottom
inc cx 
call printdot ;middelebottom
inc cx 
call printdot ;rightottom
dec dx 
call printdot ;right
dec dx 
call printdot ;righttop
mov ah, 00h
int 1Ah
mov [start_ticks], dx
checkmouseposbefore:
mov ah, 01h     
int 16h         
je didntpress1
call keypressedmc
didntpress1:
mov ax,3h
int 33h
shr cx,1
sub dx, 1
cmp cx, [x]
jne paintback
cmp dx, [y]
jne paintback
check5s:	
mov ah, 00h
int 1Ah
mov bx, dx
sub bx, [start_ticks]
cmp bx, 91
jge paintback
jmp checkmouseposbefore
startingpoint: 
inc si
cmp si, 65000
jne timehasentpassed2
add di, 10
cmp di, [voidspeed]
jl timehasentpassed2
call void
mov si, 0
timehasentpassed2:	
mov ax,3h
int 33h
mov [savexforstar], cx
mov [saveyforstar], dx
shr cx,1
sub dx, 1
mov [x], cx
mov [y], dx
mov al, 4
mov [color], al
mov ah, 01h     
int 16h    
je didntpress2     
call keypressedmc
didntpress2:
call printdot ;middeletop
dec cx
mov bh,0h
mov ah,0Dh
int 10h 
cmp al, [backroundcolor]
je lefttop
call differentcolor
lefttop: call printdot ;lefttop
inc dx 
call printdot ;left
inc dx 
mov bh,0h
mov ah,0Dh
int 10h 
cmp al, [backroundcolor]
je leftbottom
call differentcolor
leftbottom: call printdot;leftbottom
inc cx 
call printdot ;middelebottom
inc cx 
mov bh,0h
mov ah,0Dh
int 10h 
cmp al, [backroundcolor]
je rightottom
call differentcolor
rightottom: call printdot ;rightottom
dec dx 
call printdot ;right
dec dx 
mov bh,0h
mov ah,0Dh
int 10h 
cmp al, [backroundcolor]
je righttop
call differentcolor
righttop: call printdot ;righttop
checkmousepos:
mov ah, 01h     
int 16h         
je didntpress3
call keypressedmc
didntpress3:
inc si
cmp si, 65000
jne timehasentpassed
inc di
cmp di, [voidspeed]
jl timehasentpassed
call void
mov si, 0
mov ax,3h
int 33h
shr cx,1
sub dx, 1
dec cx
cmp cx, [linevoidx]
jne timehasentpassed
jmp yescolorb
timehasentpassed:	
mov ax,3h
int 33h
shr cx,1
sub dx, 1
comparecx:	cmp cx, [x]
jne paintback
cmp dx, [y]
je checkmousepos
paintback:
mov ax,3h
int 33h	
shr cx,1
sub dx, 1
mov al, [backroundcolor]
mov [color], al
mov cx, [x]
mov dx, [y]
call printdot
dec cx
call printdot
inc dx 
call printdot
inc dx 
call printdot
inc cx 
call printdot
inc cx 
call printdot
dec dx 
call printdot
dec dx 
call printdot
inc si
cmp si, 65000
jne jumpstartingpoint
add di, 10
cmp di, [voidspeed]
jl jumpstartingpoint
call void
mov si, 0
jumpstartingpoint:	
jmp startingpoint

keypressedmc:
mov ah, 00h     
int 16h
cmp al, 27
je escapepause
ret

ret
endp mousechecking
proc keyboardchecking
call drawCube
mov si, 0
mov di, 0
mov [delaytimeval], 10
call delaytime
clearkeyboard:
mov ah, 01h
int 16h
jz keyboardcleared
mov ah, 00h
int 16h
jmp clearkeyboard
keyboardcleared:
int 21h
mov ah, 00h
int 1Ah
mov [start_ticks], dx
checkmovebefore:	mov ah, 01h     
int 16h         
jne escapebeforemoveloop
mov ah, 00h
int 1Ah
mov bx, dx
sub bx, [start_ticks]
cmp bx, 91
jge moveLoop
jmp checkmovebefore

escapebeforemoveloop:
mov ah, 00h     
int 16h
cmp ah, 01h
je escapepause

moveLoop:
mov ah, 01h     
int 16h         
jne keypressed ;checks if no key pressed
inc si
cmp si, 65000
jne timehasentpassed3
add di, 10
cmp di, [voidspeedk]
jl timehasentpassed3
call void
mov si, 0
mov bx, [xk]
shr bx, 1
dec bx
cmp bx, [linevoidx]
jne timehasentpassed3
call differentcolor
timehasentpassed3:	
jmp moveLoop
keypressed:	mov ah, 00h     
int 16h
add di, 25

cmp ah, [moveupk]  
je moveUp
cmp ah, [movedownk]
je moveDown
cmp ah, [moveleftk]    
je moveLeft
cmp ah, [moverightk]  
je moveRight
cmp ah, 01h
je escapepause
jmp moveLoop    

moveUp:
call deletecube
sub [yk], 3       
call drawCube
jmp moveLoop

moveDown:
call deletecube
add [yk], 3     
call drawCube
jmp moveLoop

moveLeft:
call deletecube
sub [xk], 3      
call drawCube
jmp moveLoop
	
moveRight:
call deletecube
add [xk], 3     
call drawCube
jmp moveLoop
proc drawCube
mov al, 4
mov [color], al
mov cx, [xk]
mov dx, [yk]
shr cx,1
sub dx, 1
call printdot ;middeletop
dec cx
mov bh,0h
mov ah,0Dh
int 10h 
cmp al, [backroundcolor]
je lefttopk
call differentcolor
lefttopk: call printdot ;lefttop
inc dx 
call printdot ;left
inc dx 
mov bh,0h
mov ah,0Dh
int 10h 
cmp al, [backroundcolor]
je leftbottomk
call differentcolor
leftbottomk: call printdot;leftbottom
inc cx 
call printdot ;middelebottom
inc cx 
mov bh,0h
mov ah,0Dh
int 10h 
cmp al, [backroundcolor]
je rightottomk
call differentcolor
rightottomk: call printdot ;rightottom
dec dx 
call printdot ;right
dec dx 
mov bh,0h
mov ah,0Dh
int 10h 
cmp al, [backroundcolor]
je righttopk
call differentcolor
righttopk: call printdot ;righttop
ret
endp drawCube
proc deletecube
mov al, [backroundcolor]
mov [color], al
mov cx, [xk]
mov dx, [yk]
shr cx,1
sub dx, 1
call printdot
dec cx
call printdot
inc dx 
call printdot
inc dx 
call printdot
inc cx 
call printdot
inc cx 
call printdot
dec dx 
call printdot
dec dx 
call printdot
ret
endp deletecube
ret
endp keyboardchecking

proc escapepause
; close the speaker
in al, 61h
and al, 11111100b
out 61h, al
cmp [normalorcrated], 1
je crated5
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'p'
mov [filename+6], '1'
call callallimage
call initmouse
call whichbuttonselct
cmp cx, 1
jne button2pn
call CloseFile
call selctsound
mov [starcount], 0
mov [gotstar], 0
mov [level], 1
mov [heartcount], 5
call startscreens

button2pn:
cmp cx, 2
jne button3pn
call CloseFile
call selctsound
; Graphic mode
mov ax, 13h
int 10h
call setbackround
call borders
cmp [level], 1
jg notlevel1esc
call level1
jmp aftercallinglevelesc
notlevel1esc:	cmp [level], 2
jg notlevel2esc
call level2
jmp aftercallinglevelesc
notlevel2esc:	cmp [level], 3
jg notlevel3esc
call level3
jmp aftercallinglevelesc
notlevel3esc:	cmp [level], 4
jg notlevel4esc
call level4
jmp aftercallinglevelesc
notlevel4esc: call level5
jmp aftercallinglevelesc

aftercallinglevelesc:
call resetsavedpos
call voidafterstar
cmp [bombsonoroff], 1
je bombsoffec
cmp [countforbombexp], 0
je bombsoffec
mov [currentbomb], 0
mov [color], 17
call firstbomb
mov [color], 17
call firstbomb
mov [color], 17
call firstbomb
bombsoffen:
call drawamountofstars
cmp [gotstar], 1
je gotstaren
mov cx, [sstarx]
mov dx, [sstary]
mov [starx], cx
mov [stary], dx
call actuallydrawthestar
gotstaren:
cmp [peaceful], 1
je peacefulmodeen
call drawamountofhearts
peacefulmodeen:
cmp [keyboardormouse], 1
je iskbdiffcr4
call setmousesnsitivity
call startingpoint
iskbdiffcr4:	call setmousesnsitivity
call drawCube
call moveLoop

button3pn:
call CloseFile
call selctsound
mov [starcount], 0
mov [gotstar], 0
mov [level], 1
mov [heartcount], 5
call restart

crated5:
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'p'
mov [filename+6], '2'
call callallimage
call initmouse
call whichbuttonselct
cmp cx, 1
jne button2pdc
call CloseFile

; Graphic mode
mov ax, 13h
int 10h
call selctsound
mov [starcount], 0
mov [gotstar], 0
mov [level], 1
mov [heartcount], 5
call levelcreator

button2pdc:
cmp cx, 2
jne button3pdc
call CloseFile

; Graphic mode
mov ax, 13h
int 10h
call setbackround
call borders
call mapcrated	
call resetsavedpos
call voidafterstar
cmp [bombsonoroff], 1
je bombsoffec
cmp [countforbombexp], 0
je bombsoffec
mov [currentbomb], 0
mov [color], 17
call firstbomb
mov [color], 17
call firstbomb
mov [color], 17
call firstbomb
bombsoffec:
call drawamountofstars
cmp [gotstar], 1
je gotstarec
mov cx, [sstarx]
mov dx, [sstary]
mov [starx], cx
mov [stary], dx
call actuallydrawthestar
gotstarec:
cmp [peaceful], 1
je peacefulmodeec
call drawamountofhearts
peacefulmodeec:
cmp [keyboardormouse], 1
je iskbdiffcr3
call startingpoint
iskbdiffcr3:	call drawCube
call moveLoop

button3pdc:
call CloseFile
call selctsound
; Graphic mode
mov ax, 13h
int 10h
mov [starcount], 0
mov [gotstar], 0
mov [level], 1
mov [heartcount], 5
call restart

ret
endp escapepause
proc void
timehaspassed:	mov cx, [linevoidx]
inc cx
mov [linevoidx], cx
mov [color], 1
mov [liney], 0
mov [linex], cx
mov [linemaxy], 200
inc cx
mov [linemaxx], cx
call verline
mov di, 0
cmp [bombsonoroff], 1
je dontdeleteyet
cmp [countforbomb], 90
jl notbombyet
inc [countforbombexp]
; open speaker
in al, 61h
or al, 00000011b
out 61h, al
; send control word to change frequency
mov al, 0B6h
out 43h, al
mov ax, [note]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
sub [note], 100
cmp [countforbombexp], 1
jl dontdrawbombyet
cmp [countforbombexp], 3
jg dontdrawbombyet
call drawbomb
dontdrawbombyet:
cmp [countforbombexp], 20
jl notexpyet
mov [currentbomb], 0
call drawexplosion
; send control word to change frequency
mov al, 0B6h
out 43h, al
; play frequency 131Hz
mov ax, [noteC6]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteG5]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteE5]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteC4]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteA3]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
; close the speaker
in al, 61h
and al, 11111100b
out 61h, al
mov [countforbomb], 0
mov [countforbombexp], 0
mov [countforendexp], 0
mov [note], 6000
mov [deleteordraw], 1
cmp [keyboardormouse], 1
je dontdeleteyet
jmp paintback
notexpyet: 
notbombyet:
inc [countforbomb]
cmp [deleteordraw], 1
jne dontdeleteyet
call drawexplosion
mov [deleteordraw], 0
dontdeleteyet:
ret
endp void
proc differentcolor
mov bh,0h
mov ah,0Dh
int 10h 
cmp al, [linescolor]
jne notcolorb
yescolorb:	cmp [peaceful], 1
je peacefulmodev
dec [heartcount]
call heartshandler
call restart
notcolorb: cmp al, 1
jne notvoid
cmp [peaceful], 1
je peacefulmodev
dec [heartcount]
call heartshandler
call restart
peacefulmodev:
; open speaker
in al, 61h
or al, 00000011b
out 61h, al
; send control word to change frequency
mov al, 0B6h
out 43h, al
; play frequency 131Hz
mov ax, [noteC5]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteG4]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteE4]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
; close the speaker
in al, 61h
and al, 11111100b
out 61h, al
call restart
notvoid: cmp al, 41
je yescolorb
cmp al, 40
je yescolorb
cmp al, [bordercolor]
je yescolorb
cmp al, 17
jne notbomb
mov [currentbomb], 0
call drawexplosion
notbomb:
cmp al, 44
jne notstar
inc [starcount]
mov [gotstar], 1
call starhandler
; Graphic mode
mov ax, 13h
int 10h
call setbackround
call borders
cmp [normalorcrated], 1
je crated3
cmp [level], 1
jg notlevel1star
call level1
jmp aftercallinglevelstar
notlevel1star:	cmp [level], 2
jg notlevel2star
call level2
jmp aftercallinglevelstar
notlevel2star:	cmp [level], 3
jg notlevel3star
call level3
jmp aftercallinglevelstar
notlevel3star:	cmp [level], 4
jg notlevel4star
call level4
jmp aftercallinglevelstar
notlevel4star: call level5
jmp aftercallinglevelstar
crated3:
call mapcrated
aftercallinglevelstar:	
call resetsavedpos
call voidafterstar
cmp [bombsonoroff], 1
je bombsoffstar
cmp [countforbombexp], 0
je bombsoffstar
mov [currentbomb], 0
mov [color], 17
call firstbomb
mov [color], 17
call firstbomb
mov [color], 17
call firstbomb
bombsoffstar:
call drawamountofstars
cmp [peaceful], 1
je peacefulmodes
call drawamountofhearts
peacefulmodes:
cmp [keyboardormouse], 1
je iskbdiffcr2
call startingpoint
iskbdiffcr2:	call drawCube
call moveLoop
notstar:	cmp al, 117
je leveldone
cmp [keyboardormouse], 1
je iskbdiffcr
call mousechecking
iskbdiffcr:
call keyboardchecking
leveldone:	inc [level]
cmp [level], 6
je youwon
cmp [normalorcrated], 1
jne notcrated6
mov cl, [maxlevel]
add cl, 2
cmp cl, [level]
je youwon
notcrated6:
mov [gotstar], 0
mov [firsttimeinlevel], 1
call restart
mov ah, 00h
int 16h
ret
endp differentcolor
ret
endp playerdrawingandchecks
proc starprocs
proc drawstar
cmp [normalorcrated], 1
jne startstar
cmp [starxposc], 500
je startstar
mov cx, [starxposc]
mov dx, [staryposc]
mov [starx], cx
mov [stary], dx
jmp actuallydrawthestar
startstar:
mov ax, 40h
mov es, ax
mov cx, 10
mov bx, 0
call randomcoordy
mov dx, [stary]
call randomcoordx
mov cx, [starx]
mov bh,0h
mov ah,0Dh
int 10h 
cmp al, [backroundcolor]
jne startstar
sub cx, 5
add dx, 3
mov bh,0h
mov ah,0Dh
int 10h 
cmp al, [backroundcolor]
jne startstar
add cx, 2
add dx, 4
mov bh,0h
mov ah,0Dh
int 10h 
cmp al, [backroundcolor]
jne startstar
add cx, 3
sub dx, 3
mov bh,0h
mov ah,0Dh
int 10h 
cmp al, [backroundcolor]
jne startstar
add cx, 3
add dx, 3
mov bh,0h
mov ah,0Dh
int 10h 
cmp al, [backroundcolor]
jne startstar
add cx, 2
sub dx, 4
mov bh,0h
mov ah,0Dh
int 10h 
cmp al, [backroundcolor]
jne startstar


actuallydrawthestar:
mov [color], 44

mov cx, [starx]
mov dx, [stary]
mov [sstarx], cx
mov [sstary], dx
call printdot
dec cx
inc dx
call printdot
dec cx
inc dx
call printdot
dec cx
inc dx
call printdot
dec cx
call printdot
dec cx
;
call printdot
inc cx
inc dx
call printdot
inc cx
inc dx
call printdot
inc dx
call printdot
inc dx
;
call printdot
inc cx
dec dx
call printdot
inc cx
dec dx
call printdot
inc cx
dec dx
;
call printdot
inc cx
inc dx
call printdot
inc cx
inc dx
call printdot
inc cx
inc dx
;
call printdot
dec dx
call printdot
dec dx
call printdot
inc cx
dec dx
call printdot
inc cx
dec dx
;
call printdot
dec cx
call printdot
dec cx
call printdot
dec cx
dec dx
call printdot
dec cx
dec dx
call printdot
mov cx, [starx]
mov dx, [stary]
mov [liney], dx
mov [linex], cx
add dx, 4
mov [linemaxy], dx
call onepixellinever
mov cx, [starx]
mov dx, [stary]
inc cx
inc dx
mov [liney], dx
mov [linex], cx
add dx, 4
mov [linemaxy], dx
call onepixellinever
sub dx, 2
inc cx
mov [liney], dx
mov [linex], cx
add dx, 4
mov [linemaxy], dx
call onepixellinever
sub dx, 3
inc cx
call printdot
mov cx, [starx]
mov dx, [stary]
mov [liney], dx
mov [linex], cx
add dx, 4
mov [linemaxy], dx
call onepixellinever
mov cx, [starx]
mov dx, [stary]
dec cx
inc dx
mov [liney], dx
mov [linex], cx
add dx, 4
mov [linemaxy], dx
call onepixellinever
sub dx, 2
dec cx
mov [liney], dx
mov [linex], cx
add dx, 4
mov [linemaxy], dx
call onepixellinever
sub dx, 3
dec cx
call printdot
ret
endp drawstar
proc randomcoordy
xor si, si
randloopy:    
mov ax, [Clock]          
xor al, [cs:bx]          
and al, 01111111b        
cmp al, 90
jg randloopy             
add [stary], ax          
inc si                   
cmp si, 2                
jl randloopy             
add [stary], 10          
ret
endp randomcoordy
proc randomcoordx
xor si, si               
randloopx:    
mov ax, [Clock]          
xor al, [cs:bx]          
and al, 01111111b        
cmp al, [backroundcolor]
jg randloopx             
add [starx], ax          
inc si                   
cmp si, 3                
jl randloopx             
add [starx], 10          
ret
endp randomcoordx
proc voidafterstar
mov [color], 1
mov [liney], 0
mov [linex], 0
mov [linemaxy], 200
mov cx, [linevoidx]
inc cx
mov [linemaxx], cx
call hozline
ret
endp voidafterstar
ret
endp starprocs
proc ingscreens
proc starhandler

mov [filename+5], 's'
mov cl, [starcount]
add cl, 48
cmp [normalorcrated], 1
jne notcrated2
cmp [maxlevel], 0
jne stars2
add cl, 5
jmp notcrated2
stars2:
cmp [maxlevel], 1
jne stars3
mov [filename+4], 's'
mov [filename+5], cl
mov [filename+6], '1'
jmp crated6
stars3:
mov [filename+4], 's'
mov [filename+5], cl
mov [filename+6], '2'
jmp crated6
notcrated2:
mov [filename+6], cl
crated6:
call callallimage
mov [filename+4], 'e'
; open speaker
in al, 61h
or al, 00000011b
out 61h, al
; send control word to change frequency
mov al, 0B6h
out 43h, al
; play frequency 131Hz
mov ax, [noteC4]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteE4]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteG4]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
; close the speaker
in al, 61h
and al, 11111100b
out 61h, al
mov [delaytimeval], 36
call delaytime
call CloseFile
ret
endp starhandler
proc heartshandler
mov [filename+5], 'h'
mov cl, [heartcount]
add cl, 48
mov [filename+6], cl
call callallimage
cmp [heartcount], 0
jne didntcompletlylose
; open speaker
in al, 61h
or al, 00000011b
out 61h, al
; send control word to change frequency
mov al, 0B6h
out 43h, al
; play frequency 131Hz
mov ax, [noteG4]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteDSharp4]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteFSharp4]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteC4]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteG3]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
; close the speaker
in al, 61h
and al, 11111100b
out 61h, al
mov [starcount], 0
mov [gotstar], 0
mov [level], 1
mov [heartcount], 5
checkenterlost:
mov ah, 00h     
int 16h
cmp al, 13      
jne checkenterlost    
call CloseFile
cmp [normalorcrated], 1
je crated4
mov [filename+5], 'e'
mov [filename+6], '1'
call callallimage   
call initmouse
button1lost:
call whichbuttonselct
cmp cx, 1
jne button3lost
call selctsound
call startscreens

button3lost:
cmp cx, 3
jne button1lost
call selctsound
call restart

crated4:
mov [filename+5], 'e'
mov [filename+6], '2'
call callallimage
call initmouse
call whichbuttonselct
cmp cx, 1
jne button2lc
call selctsound
call startscreens

button2lc:
cmp cx, 2
jne button3lc
call selctsound
call levelcreator

button3lc:
call selctsound
call restart

didntcompletlylose:
; open speaker
in al, 61h
or al, 00000011b
out 61h, al
; send control word to change frequency
mov al, 0B6h
out 43h, al
; play frequency 131Hz
mov ax, [noteC5]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteG4]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteE4]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
; close the speaker
in al, 61h
and al, 11111100b
out 61h, al
mov [delaytimeval], 36
call delaytime
call CloseFile
ret
endp heartshandler
proc levelhandler
mov ax, 2h
int 33h
mov [filename+5], 'l'
mov cl, [level]
add cl, 48
mov [filename+6], cl
call callallimage
cmp [level], 1
je startedplaying
; open speaker
in al, 61h
or al, 00000011b
out 61h, al
; send control word to change frequency
mov al, 0B6h
out 43h, al
; play frequency 131Hz
mov ax, [noteC5]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteE5]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteG5]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteC6]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
; close the speaker
in al, 61h
and al, 11111100b
out 61h, al
startedplaying:	mov [delaytimeval], 36
call delaytime
call CloseFile
ret
endp levelhandler
ret
endp ingscreens
proc howmanystarsandhearts
proc drawamountofstars
mov [color], 14
mov [staramountx], 270
mov [forstarloop], 0
actuallydrawamountstars:
mov cx, [staramountx]
mov [liney], 0
mov [linex], cx
mov [linemaxy], 3
call onepixellinever
dec cx
mov dx, 1
call printdot
add cx, 2
call printdot
sub [staramountx], 5
inc [forstarloop]
mov al, [forstarloop]
cmp al, [starcount]
jl actuallydrawamountstars
ret
endp drawamountofstars
proc drawamountofhearts
mov [color], 39
mov [heartamountx], 300
mov [forstarloop], 0
actuallydrawamounthearts:
mov cx, [heartamountx]
mov [liney], 0
mov [linex], cx
mov [linemaxy], 3
call onepixellinever
dec cx
mov dx, 1
call printdot
add cx, 2
call printdot
sub [heartamountx], 5
inc [forstarloop]
mov al, [forstarloop]
cmp al, [heartcount]
jl actuallydrawamounthearts
ret
endp drawamountofhearts
ret
endp howmanystarsandhearts
proc youwon
mov [filename+5], 'w'
mov cl, [starcount]
add cl, 48
cmp [normalorcrated], 1
jne notcrated3
cmp [maxlevel], 0
jne stars2w
add cl, 6
jmp notcrated3
stars2w:
cmp [maxlevel], 1
jne stars3w
mov [filename+4], 'w'
mov [filename+5], cl
mov [filename+6], '1'
jmp crated7
stars3w:
mov [filename+4], 'w'
mov [filename+5], cl
mov [filename+6], '2'
jmp crated7
notcrated3:
mov [filename+6], cl
crated7:
call callallimage
mov [filename+4], 'e'
; open speaker
in al, 61h
or al, 00000011b
out 61h, al
; send control word to change frequency
mov al, 0B6h 
out 43h, al
; play frequency 131Hz
mov ax, [noteG4]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteA4]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteB4]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteD5]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteG5]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteE5]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteC5]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteG4]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
; close the speaker
in al, 61h
and al, 11111100b
out 61h, al
mov [starcount], 0
mov [gotstar], 0
mov [level], 1
mov [heartcount], 5
checkenterwon:
mov ah, 00h     
int 16h
cmp al, 13      
jne checkenterwon    
call CloseFile
cmp [normalorcrated], 1
je crated2
mov [filename+5], 'e'
mov [filename+6], '1'
call callallimage   
call initmouse
button1won:
call whichbuttonselct
cmp cx, 1
jne button3won
call selctsound
call startscreens

button3won:
cmp cx, 3
jne button1won
call selctsound
call restart

crated2:
mov [filename+5], 'e'
mov [filename+6], '2'
call callallimage
call initmouse
call whichbuttonselct
cmp cx, 1
jne button2wonc
call selctsound
call startscreens

button2wonc:
cmp cx, 2
jne button3wonc
call selctsound
call levelcreator

button3wonc:
call selctsound
call restart

ret
endp youwon
proc startscreens
mov [whichscreen], 0
call CloseFile
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'n'
mov [filename+6], '0'
call callallimage
call initmouse
button1dorc:
call whichbuttonselct
cmp cx, 1
jne button3dorc
mov [normalorcrated], 1
mov [backroundcolor], 100

cmp [mapinfo+6], 0
je levelcreatorscreens
mov ax, [mapinfo]
mov [linescolor], al

mov ax, [mapinfo + 2]
mov [backroundcolor], al

mov ax, [mapinfo + 4]
mov [bordercolor], al

mov ax, [mapinfo + 6]
mov [bordersize], ax

mov ax, [mapinfo + 8]
mov [playerxposc], ax

mov ax, [mapinfo + 10]
mov [playeryposc], ax

mov ax, [mapinfo + 12]
mov [starxposc], ax

mov ax, [mapinfo + 14]
mov [staryposc], ax
jmp levelcreatorscreens

button3dorc:
cmp cx, 3
jne button1dorc
mov [normalorcrated], 0
mov [backroundcolor], 100
mov [linescolor], 0
mov [bordercolor], 0
mov [bordersize], 3
mov [playerxposc], 10
mov [playeryposc], 100
mov [starxposc], 500
mov [staryposc], 500
jmp keyboardormousescreen


keyboardormousescreen:
mov [whichscreen], 0
jmp choseset


didntchooseset:
call CloseFile
call selctsound
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'n'
mov [filename+6], '1'
call callallimage
call initmouse
button1korm:
call whichbuttonselct
cmp cx, 1
jne button3korm
mov [keyboardormouse], 0
jmp changemouse

button3korm:
cmp cx, 3
jne button1korm
mov [keyboardormouse], 1
jmp keyboardchange

changemouse:
call CloseFile
call selctsound
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'm'
mov [filename+6], '1'
call callallimage
call initmouse
button1cm:
call whichbuttonselct
cmp cx, 1
jne button3cm
jmp changemspeed


button3cm:
cmp cx, 3
jne button1cm
jmp whichgamemode

changemspeed:
call CloseFile
call selctsound
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'm'
mov [filename+6], '2'
call callallimage
call initmouse
call whichbuttonselct
cmp cx, 1
jne button2ms
mov [mousexspeed], 256
mov [mouseyspeed], 512
jmp whichgamemode

button2ms:
cmp cx, 2
jne button3ms
mov [mousexspeed], 128
mov [mouseyspeed], 256
jmp whichgamemode

button3ms:
mov [mousexspeed], 64
mov [mouseyspeed], 128
jmp whichgamemode

whichgamemode:
call CloseFile
call selctsound
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'n'
mov [filename+6], '2'
call callallimage
call initmouse
call whichbuttonselct
cmp cx, 1
jne button2wg
mov [peaceful], 1
jmp bombsonoroffscreen

button2wg:
cmp cx, 2
jne button3wg
mov [voidspeed], 20
mov [voidspeedk], 250
jmp bombsonoroffscreen

button3wg:
mov [voidspeed], 10
mov [voidspeedk], 125
jmp bombsonoroffscreen


bombsonoroffscreen:	
call CloseFile
call selctsound
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'n'
mov [filename+6], '3'
call callallimage
call initmouse
button1bomb:
call whichbuttonselct
cmp cx, 1
jne button3bomb
mov [bombsonoroff], 0
call CloseFile
call selctsound
call restart

button3bomb:
cmp cx, 3
jne button1bomb
mov [bombsonoroff], 1
call CloseFile
call selctsound
call restart

keyboardchange:
call CloseFile
call selctsound
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'k'
mov [filename+6], '1'
call callallimage
call initmouse
button1ck:
call whichbuttonselct
cmp cx, 1
jne button3ck
jmp changekeys

button3ck:
cmp cx, 3
jne button1ck
jmp whichgamemode


changekeys:
call CloseFile
call selctsound
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'k'
mov [filename+6], '2'
call callallimage
call initmouse
call whichbuttonselct
cmp cx, 1
jne button2kc
mov [moveupk], 48h
mov [moveleftk], 4bh
mov [movedownk], 50h
mov [moverightk], 4dh   
jmp whichgamemode

button2kc:
cmp cx, 2
jne button3kc
mov [moveupk], 11h
mov [moveleftk], 1eh
mov [movedownk], 1fh
mov [moverightk], 20h
jmp whichgamemode

button3kc:
mov [moveupk], 17h
mov [moveleftk], 24h
mov [movedownk], 25h
mov [moverightk], 26h
jmp whichgamemode

levelcreatorscreens:
cmp [xmaxcreator+0], 0
jne hasamapalready
call CloseFile
call selctsound
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'c'
mov [filename+6], '1'
call callallimage
call initmouse
button1imporc:
call whichbuttonselct
cmp cx, 1
jne button3imporc
call selctsound
jmp importmap

button3imporc:
cmp cx, 3
jne button1imporc
call selctsound
call keyactionsguide
jmp levelcreator

hasamapalready:
call CloseFile
call selctsound
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'c'
mov [filename+6], 'c'
call callallimage
call initmouse
call whichbuttonselct
cmp cx, 1
jne button2imporc2
call selctsound
jmp importmap

button2imporc2:
cmp cx, 2
jne button3imporc2
call selctsound
call CloseFile
jmp levelcreator

button3imporc2:
jmp areyousuredelete

areyousuredelete:
call CloseFile
call selctsound
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'c'
mov [filename+6], 'd'
call callallimage
call initmouse
call whichbuttonselct
cmp cx, 1
jne button2rus
call selctsound
call CloseFile
jmp exportmaps

button2rus:
cmp cx, 2
jne button3rus
call CloseFile
jmp levelcreatorscreens

button3rus:
call selctsound
mov [bordersize], 3
mov [playerxposc], 10
mov [playeryposc], 100
mov [starxposc], 500
mov [staryposc], 500
mov [backroundcolor], 100
mov [linescolor], 0
mov [bordercolor], 0
mov [currentlevelc], 0
mov [maxlevel], 0
mov cx, 150
lea si, [yscreator]
reset_yscreator2:
mov ax, 0
mov [si], ax
add si, 2
loop reset_yscreator2
; Reset xscreator
mov cx, 150
lea si, [xscreator]
reset_xscreator2:
mov ax, 0
mov [si], ax
add si, 2
loop reset_xscreator2
; Reset yendcreator
mov cx, 150
lea si, [ymaxcreator]
reset_yendcreator2:
mov ax, 0
mov [si], ax
add si, 2
loop reset_yendcreator2
; Reset xendcreator
mov cx, 150
lea si, [xmaxcreator]
reset_xendcreator2:
mov ax, 0
mov [si], ax
add si, 2
loop reset_xendcreator2
call CloseFile
jmp levelcreator

choseset:
call CloseFile
call selctsound
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'n'
mov [filename+6], '4'
call callallimage
call initmouse
button1cs:
call whichbuttonselct
cmp cx, 1
jne button3cs
jmp didntchooseset

button3cs:
cmp cx, 3
jne button1cs
jmp whichgamemode

checkescape:
mov ah, 01h     
int 16h         
jne keypresseds
ret
keypresseds:
mov ah, 00h     
int 16h
cmp al, 27     
je escapepressed
ret
escapepressed:
call CloseFile
call startscreens

ret 
endp startscreens
proc whichbuttonselct
MouseLP :
mov ax,3h
int 33h
cmp bx, 01h ; check left mouse click
je pressed
cmp [whichscreen], 0
jne notamainsc
call checkescape
jmp MouseLP
notamainsc:
call checkescapel
jmp MouseLP
pressed:
shr cx,1
sub dx, 1
cmp cx, 108
jg button2
cmp dx, 118
jl MouseLP
cmp dx, 174
jg MouseLP
cmp cx, 3
jl MouseLP
mov cx, 1
ret

button2:
cmp cx, 212
jg button3
cmp dx, 97
jl MouseLP
cmp dx, 152
jg MouseLP
cmp cx, 108
jl MouseLP
mov cx, 2
ret

button3:
cmp cx, 318
jg MouseLP
cmp dx, 118
jl MouseLP
cmp dx, 174
jg MouseLP
cmp cx, 214
jl MouseLP
mov cx, 3
ret
endp whichbuttonselct
proc importandexportprocs
proc filehandlerformap
CloseFile2:
    mov ah, 3Eh         ; Close file
    mov bx, [filehandle2]
    int 21h
    ret

OpenFileWritemap:
    mov ah, 3Ch         ; Create or open file for writing
    mov cx, 0           ; Mode: read/write (0)
    lea dx, [filenamemap]
    int 21h
    mov [filehandle2], ax
    ret

WriteToFilexs:
    mov ah, 40h         ; Write to file
    mov bx, [filehandle2]
    mov cx, 300         ; Number of bytes to write (adjust as needed)
    lea dx, [xscreator]
    int 21h
    ret



WriteToFileys:
    mov ah, 40h         ; Write to file
    mov bx, [filehandle2]
    mov cx, 300         ; Number of bytes to write (adjust as needed)
    lea dx, [yscreator]
    int 21h
    ret



WriteToFilexe:
    mov ah, 40h         ; Write to file
    mov bx, [filehandle2]
    mov cx, 300         ; Number of bytes to write (adjust as needed)
    lea dx, [xmaxcreator]
    int 21h
    ret


WriteToFileye:
    mov ah, 40h         ; Write to file
    mov bx, [filehandle2]
    mov cx, 300         ; Number of bytes to write (adjust as needed)
    lea dx, [ymaxcreator]
    int 21h
    ret
	

WriteToFilesc:
    mov ah, 40h         ; Write to file
    mov bx, [filehandle2]
    mov cx, 300         ; Number of bytes to write (adjust as needed)
    lea dx, [savecolorarr]
    int 21h
    ret
	
WriteToFilemi:
    mov ah, 40h         ; Write to file
    mov bx, [filehandle2]
    mov cx, 16        ; Number of bytes to write (adjust as needed)
    lea dx, [mapinfo]
    int 21h
    ret
	

ReadFromFilexs:
    mov ah, 3Fh         ; Read from file
    mov bx, [filehandle2]
    mov cx, 300         ; Number of bytes to read (adjust as needed)
    lea dx, [xscreator]
    int 21h
	jc FailedToImport
    ret

ReadFromFileys:
    mov ah, 3Fh         ; Read from file
    mov bx, [filehandle2]
    mov cx, 300         ; Number of bytes to read (adjust as needed)
    lea dx, [yscreator]
    int 21h
	jc FailedToImport
    ret

ReadFromFilexe:
    mov ah, 3Fh         ; Read from file
    mov bx, [filehandle2]
    mov cx, 300         ; Number of bytes to read (adjust as needed)
    lea dx, [xmaxcreator]
    int 21h
	jc FailedToImport
    ret

ReadFromFileye:
    mov ah, 3Fh         ; Read from file
    mov bx, [filehandle2]
    mov cx, 300         ; Number of bytes to read (adjust as needed)
    lea dx, [ymaxcreator]
    int 21h
	jc FailedToImport
    ret
	
ReadFromFilesc:
    mov ah, 3Fh         ; Read from file
    mov bx, [filehandle2]
    mov cx, 300         ; Number of bytes to read (adjust as needed)
    lea dx, [savecolorarr]
    int 21h
	jc FailedToImport
    ret
	
ReadFromFilemi:
    mov ah, 3Fh         ; Read from file
    mov bx, [filehandle2]
    mov cx, 16         ; Number of bytes to read (adjust as needed)
    lea dx, [mapinfo]
    int 21h
	jc FailedToImport
    ret

OpenFileReadmap:
    mov ah, 3Dh         ; Open existing file for reading
    mov al, 0           ; Mode: read-only (0)
    lea dx, [filenamemap]
    int 21h
	jc FailedToImport
    mov [filehandle2], ax
    ret

	ret
	endp filehandlerformap
proc importmap
call CloseFile
mov [delaytimeval], 2
call delaytime
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'c'
mov [filename+6], '2'
call callallimage
checkenterimport:
mov ah, 00h     
int 16h
cmp al, 13      
je yesenterimport
cmp al, 27  
jne checkenterimport
call startscreens
yesenterimport:
call OpenFileReadmap
call ReadFromFilexs
call ReadFromFileys
call ReadFromFilexe
call ReadFromFileye
call ReadFromFilesc
call ReadFromFilemi
call CloseFile2
mov ax, [mapinfo]
mov [linescolor], al

mov ax, [mapinfo + 2]
mov [backroundcolor], al

mov ax, [mapinfo + 4]
mov [bordercolor], al

mov ax, [mapinfo + 6]
mov [bordersize], ax

mov ax, [mapinfo + 8]
mov [playerxposc], ax

mov ax, [mapinfo + 10]
mov [playeryposc], ax

mov ax, [mapinfo + 12]
mov [starxposc], ax

mov ax, [mapinfo + 14]
mov [staryposc], ax
mov [currentlevelc], 0
call keyactionsguide
call levelcreator
ret
endp importmap
proc exportmaps
call selctsound
call CloseFile
mov [delaytimeval], 2
call delaytime
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'c'
mov [filename+6], '5'
call callallimage
checkenterexport:
mov ah, 00h     
int 16h
cmp al, 13      
je yesenterexport
cmp al, 27  
jne checkenterexport
jmp playorsavemap
yesenterexport:
call OpenFileWritemap
call WriteToFilexs
call WriteToFileys
call WriteToFilexe
call WriteToFileye
call WriteToFilesc
call WriteToFilemi
call CloseFile2
call CloseFile
mov [delaytimeval], 2
call delaytime
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'c'
mov [filename+6], '6'
call callallimage
; open speaker
in al, 61h
or al, 00000011b
out 61h, al
; send control word to change frequency
mov al, 0B6h
out 43h, al
; play frequency 131Hz
mov ax, [noteC5]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteE5]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteG5]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteC6]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
; close the speaker
in al, 61h
and al, 11111100b
out 61h, al
checkenterafterexport:
mov ah, 00h     
int 16h
cmp al, 13      
jne checkenterafterexport
jmp levelcreatorscreens
ret
endp exportmaps
proc FailedToImport  
call CloseFile 
mov [delaytimeval], 2
call delaytime
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'c'
mov [filename+6], '3'
call callallimage
checkenterimportfailed:
mov ah, 00h     
int 16h
cmp al, 13      
je yesenterimportfailed
cmp al, 27  
jne checkenterimportfailed
call startscreens
yesenterimportfailed:
call CloseFile
call OpenFileReadmap
call ReadFromFilexs
call ReadFromFileys
call ReadFromFilexe
call ReadFromFileye
call ReadFromFilesc
call ReadFromFilemi
call CloseFile2
call keyactionsguide
call levelcreator
ret
endp FailedToImport   
ret
endp importandexportprocs
proc levelcreator
mov [whichscreen], 1
mov al, [linescolor]
mov [savecolor], al
mov [currentline], 500
; Graphic mode
mov ax, 13h
int 10h
call setbackround
call borders
; Initializes the mouse
mov ax,0h
int 33h
mov [mousexspeed], 256
mov [mouseyspeed], 512
call setmousesnsitivity
mov bx, [currentlevelc]
jmp drawlinesafterreset
checkwhichaction:
; Show mouse
mov ax,1h
int 33h
mov ah, 01h     
int 16h         
jne keypressede
mov ax, 3      
int 33h 
test bx, 02h
jz leftbuttonpressed1
cmp [currentline], 0
je checkwhichaction
call rightbuttonpressed
leftbuttonpressed1:
shr cx, 1
dec dx
test bx, 1
jz checkwhichaction
mov [xstartedc], cx
mov [ystartedc], dx
dec [xstartedc]
dec [ystartedc]
mov [xprivc], cx
mov [yprivc], dx
leftbuttonpressed2:
mov ax, 3      
int 33h 
shr cx, 1
dec dx
test bx, 1
jz lineended
cmp dx, [ystartedc]
je leftbuttonpressed2
cmp cx, [xstartedc]
je leftbuttonpressed2
cmp dx, [ystartedc]
jl leftbuttonpressed2
cmp cx, [xstartedc]
jl leftbuttonpressed2
cmp dx, [yprivc]
jne drawrec
cmp cx, [xprivc]
jne drawrec
jmp leftbuttonpressed2

drawrec:
mov [xcurrentc], cx
mov [ycurrentc], dx
cmp dx, [yprivc]
jge dxisntsmaller
mov cx, [xcurrentc]
mov al, [backroundcolor]
mov [color], al
mov [linemaxx], cx
mov cx, [xstartedc]
mov dx, [ycurrentc]
mov [liney], dx
mov [linex], cx

call onepixellinehoz
dxisntsmaller:
mov cx, [xcurrentc]
cmp cx, [xprivc]
jge cxisntsmaller
mov al, [backroundcolor]
mov [color], al
mov dx, [ycurrentc]
mov [linemaxy], dx
mov cx, [xcurrentc]
mov dx, [ystartedc]

mov [liney], dx
mov [linex], cx

call onepixellinever
cxisntsmaller:
mov cx, [xcurrentc]
mov dx, [ycurrentc]
mov [xprivc], cx
mov [yprivc], dx
mov al, [savecolor]
mov [color], al
mov [linemaxy], dx
mov [linemaxx], cx
mov cx, [xstartedc]
mov dx, [ystartedc]
mov [liney], dx
mov [linex], cx

call hozline
jmp leftbuttonpressed2

lineended:
inc [xstartedc]
inc [ystartedc]
mov cx, [xstartedc]
mov dx, [ystartedc]
cmp dx, [yprivc]
jne movedatleast
cmp cx, [xprivc]
je checkwhichaction
movedatleast:
dec dx
dec cx
mov bx, [currentline]
mov [xscreator+bx], cx
mov [yscreator+bx], dx
mov cx, [xcurrentc]
mov dx, [ycurrentc]
mov [xmaxcreator+bx], cx
mov [ymaxcreator+bx], dx
mov al, [savecolor]
mov [savecolorarr+bx], al
add [currentline], 2
call setbackround
call borders
mov bx, [currentlevelc]
drawlinesafterreset:
mov cx, [playerxposc]
mov dx, [playeryposc]
mov [color], 4
call printdot ;middeletop
dec cx
call printdot ;lefttop
inc dx 
call printdot ;left
inc dx 
call printdot;leftbottom
inc cx 
call printdot ;middelebottom
inc cx 
call printdot ;rightottom
dec dx 
call printdot ;right
dec dx 
call printdot ;righttop
cmp [starxposc], 500
je didntchoosespos1
mov cx, [starxposc]
mov dx, [staryposc]
call drawstar
didntchoosespos1:
cmp [currentline], 0
je checkwhichaction
mov cx, [xmaxcreator+bx]
mov dx, [ymaxcreator+bx]
cmp cx, [xscreator+bx]
jg xscreatorisfine
mov [currentline], bx
jmp checkwhichaction
xscreatorisfine:
cmp dx, [yscreator+bx]
jg yscreatorisfine
mov [currentline], bx
jmp checkwhichaction
yscreatorisfine:
mov [linemaxy], dx
mov [linemaxx], cx
mov cx, [xscreator+bx]
mov dx, [yscreator+bx]
mov [liney], dx
mov [linex], cx
mov al, [savecolorarr+bx]
mov [color], al
call hozline
add bx, 2
cmp bx, [currentline]
jl drawlinesafterreset
mov [delaytimeval], 3
call delaytime
jmp checkwhichaction

keypressede:
mov ah, 00h     
int 16h
cmp al, 'e'     
jne notcolorend
mov [savecolor], 117
jmp checkwhichaction
notcolorend:
cmp al, 'b'     
jne notcolorbswitch
mov al, [linescolor]
mov [savecolor], al
jmp checkwhichaction
notcolorbswitch:

cmp al, 'p'     
jne savemap
playorsavemap:
xor ax, ax
mov al, [linescolor]
mov [mapinfo], ax
xor ax, ax
mov al, [backroundcolor]
mov [mapinfo + 2], ax
xor ax, ax
mov al, [bordercolor]
mov [mapinfo + 4], ax
mov ax, [bordersize]
mov [mapinfo + 6], ax
mov ax, [playerxposc]
mov [mapinfo + 8], ax
mov ax, [playeryposc]
mov [mapinfo + 10], ax
mov ax, [starxposc]
mov [mapinfo + 12], ax
mov ax, [staryposc]
mov [mapinfo + 14], ax
call CloseFile
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'c'
mov [filename+6], '4'
call callallimage
call initmouse
call selctsound
call whichbuttonselct
cmp cx, 1
jne button2eorp
call selctsound
call startscreens

button2eorp:
cmp cx, 2
jne button3eorp
mov [normalorcrated], 1
call exportmaps

button3eorp:
mov [normalorcrated], 1
call keyboardormousescreen
savemap:
cmp al, 's'     
je playorsavemap

cmp al, 27  
je playorsavemap

cmp al, 'r'     
jne changecolors
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'c'
mov [filename+6], 'b'
call callallimage
call initmouse
call whichbuttonselct
cmp cx, 1
jne button2rs
call selctsound
call CloseFile
mov bx, [currentlevelc]
mov di, [currentlevelc]
add di, 100
mov [backroundcolor], 100
mov [linescolor], 0
mov bx, 0
call updatelcp
mov bx, 100
call updatelcp
mov bx, 200
call updatelcp
mov [bordercolor], 0
call levelcreator

button2rs:
cmp cx, 2
jne button3rs
call selctsound
call CloseFile
; Reset yscreator
mov cx, 50
mov di, [currentlevelc]
lea si, [yscreator+di]
reset_yscreator:
mov ax, 0
mov [si], ax
add si, 2
loop reset_yscreator
; Reset xscreator
mov cx, 50
mov di, [currentlevelc]
lea si, [xscreator+di]
reset_xscreator:
mov ax, 0
mov [si], ax
add si, 2
loop reset_xscreator
; Reset yendcreator
mov cx, 50
mov di, [currentlevelc]
lea si, [ymaxcreator+di]
reset_yendcreator:
mov ax, 0
mov [si], ax
add si, 2
loop reset_yendcreator
; Reset xendcreator
mov cx, 50
mov di, [currentlevelc]
lea si, [xmaxcreator+di]
reset_xendcreator:
mov ax, 0
mov [si], ax
add si, 2
loop reset_xendcreator

call levelcreator

button3rs:
call selctsound
call CloseFile
mov [bordersize], 3
mov [playerxposc], 10
mov [playeryposc], 100
mov [starxposc], 500
mov [staryposc], 500
call levelcreator

changecolors:
cmp al, 'c'     
jne bordersizecheck
backtochangec:
call CloseFile
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'c'
mov [filename+6], '7'
call callallimage
call initmouse
call whichbuttonselct
cmp cx, 1
jne button2cc
call selctsound
call colorchangingexpl
call changingbackroundcolor

button2cc:
cmp cx,2 
jne button3cc
call selctsound
call colorchangingexpl
call changinglinescolor

button3cc:
call selctsound
call colorchangingexpl
call changingbordercolor

bordersizecheck:
cmp al, 'i'     
jne bordersizedec
cmp [bordersize], 8
jg checkwhichaction
inc [bordersize]
call levelcreator

bordersizedec:
cmp al, 'd'     
jne changeplace
cmp [bordersize], 1
je checkwhichaction
dec [bordersize]
call levelcreator

changeplace:
cmp al, 'o'     
jne nextlevelcheck
backtochangep:
call CloseFile
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'c'
mov [filename+6], '9'
call callallimage
call initmouse
button1cp:
call whichbuttonselct
cmp cx, 1
jne button3cp
call selctsound
call placechangingexpl
call changestarplace

button3cp:
cmp cx, 3
jne button1cp
call selctsound
call placechangingexpl
call changeplayerplace

jmp checkwhichaction

checkescapel:
mov ah, 01h     
int 16h         
jne keypressedsl
ret
keypressedsl:
mov ah, 00h     
int 16h
cmp al, 27     
je escapepressedl
ret
escapepressedl:
call levelcreator

checkenterl:
mov ah, 01h     
int 16h         
jne keypressedsler
ret
keypressedsler:
mov ah, 00h     
int 16h
cmp al, 13      
je enterpressedl
ret
enterpressedl:
call levelcreator

nextlevelcheck:
cmp al, 'n'     
jne backlevelcheck
cmp [currentlevelc], 200
je checkwhichaction
add [currentlevelc], 100
mov ax, [currentlevelc]
mov dl, 100
div dl
cmp al, [maxlevel]
jle lmaxl
mov [maxlevel], al
lmaxl:
call levelcreator

backlevelcheck:
cmp al, 'm'     
jne deletelevel
cmp [currentlevelc], 0
je checkwhichaction
sub [currentlevelc], 100
call levelcreator

deletelevel:
cmp al, 'x'     
jne callkeyactionguide
call CloseFile
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'c'
mov [filename+6], 'e'
call callallimage
call initmouse
button1dl:
call whichbuttonselct
cmp cx, 1
jne button3dl
call selctsound
call levelcreator

button3dl:
cmp cx, 3
jne button1dl
call selctsound
mov ax, [currentlevelc]
mov dl, 100
div dl
cmp al, [maxlevel]
jl lmaxl2

call CloseFile
; Reset yscreator
mov cx, 50
mov di, [currentlevelc]
lea si, [yscreator+di]
reset_yscreator3:
mov ax, 0
mov [si], ax
add si, 2
loop reset_yscreator3
; Reset xscreator
mov cx, 50
mov di, [currentlevelc]
lea si, [xscreator+di]
reset_xscreator3:
mov ax, 0
mov [si], ax
add si, 2
loop reset_xscreator3
; Reset yendcreator
mov cx, 50
mov di, [currentlevelc]
lea si, [ymaxcreator+di]
reset_yendcreator3:
mov ax, 0
mov [si], ax
add si, 2
loop reset_yendcreator3
; Reset xendcreator
mov cx, 50
mov di, [currentlevelc]
lea si, [xmaxcreator+di]
reset_xendcreator3:
mov ax, 0
mov [si], ax
add si, 2
loop reset_xendcreator3
sub [currentlevelc], 100
dec [maxlevel]
call levelcreator

lmaxl2:
cmp [currentlevelc], 100
jl level1delete
call CloseFile
call shiftlines
dec [maxlevel]
mov [normalorcrated], 1
call levelcreator

level1delete:
cmp [maxlevel], 0
je levelcreator
call shiftlines
add [currentlevelc], 100
call shiftlines
dec [maxlevel]
mov [normalorcrated], 1
call levelcreator

callkeyactionguide:
call keyactionsguide
call levelcreator

proc shiftlines
mov cx, 50
mov di, [currentlevelc]
lea si, [yscreator+di]
lea bx, [yscreator+di+100]
shiftlineys:
mov ax, [bx]
mov [si], ax
xor ax, ax
mov [bx], ax
add si, 2
add bx, 2
loop shiftlineys

mov cx, 50
mov di, [currentlevelc]
lea si, [xscreator+di]
lea bx, [xscreator+di+100]
shiftlinexs:
mov ax, [bx]
mov [si], ax
xor ax, ax
mov [bx], ax
add si, 2
add bx, 2
loop shiftlinexs

mov cx, 50
mov di, [currentlevelc]
lea si, [ymaxcreator+di]
lea bx, [ymaxcreator+di+100]
shiftlineye:
mov ax, [bx]
mov [si], ax
xor ax, ax
mov [bx], ax
add si, 2
add bx, 2
loop shiftlineye

mov cx, 50
mov di, [currentlevelc]
lea si, [xmaxcreator+di]
lea bx, [xmaxcreator+di+100]
shiftlinexe:
mov ax, [bx]
mov [si], ax
xor ax, ax
mov [bx], ax
add si, 2
add bx, 2
loop shiftlinexe

mov cx, 50
mov di, [currentlevelc]
lea si, [savecolorarr+di]
lea bx, [savecolorarr+di+100]
shiftlinec:
mov ax, [bx]
mov [si], ax
xor ax, ax
mov [bx], ax
add si, 2
add bx, 2
loop shiftlinec
ret
endp shiftlines

proc changingbackroundcolor
call CloseFile
mov [delaytimeval], 2
call delaytime
; Graphic mode
mov ax, 13h
int 10h
call setbackround
call borders
mov bx, [currentlevelc]
drawlinesbc:
mov cx, [xmaxcreator+bx]
mov dx, [ymaxcreator+bx]
cmp cx, [xscreator+bx]
jle checkwhichactionbc
cmp dx, [yscreator+bx]
jle checkwhichactionbc
mov [linemaxy], dx
mov [linemaxx], cx
mov cx, [xscreator+bx]
mov dx, [yscreator+bx]
mov [liney], dx
mov [linex], cx
mov al, [savecolorarr+bx]
mov [color], al
call hozline
add bx, 2
cmp bx, [currentline]
jl drawlinesbc
checkwhichactionbc:
call checkenterl
mov ax, 3      
int 33h 
test bx, 02h
jz leftbuttonpressedbc
dec [backroundcolor]
call changingbackroundcolor
leftbuttonpressedbc:
test bx, 1
jz checkwhichactionbc
inc [backroundcolor]
call changingbackroundcolor

ret
endp changingbackroundcolor

proc changingbordercolor
call CloseFile
mov [delaytimeval], 2
call delaytime
; Graphic mode
mov ax, 13h
int 10h
call setbackround
call borders
mov bx, [currentlevelc]
drawlinesbrc:
mov cx, [xmaxcreator+bx]
mov dx, [ymaxcreator+bx]
cmp cx, [xscreator+bx]
jle checkwhichactionbrc
cmp dx, [yscreator+bx]
jle checkwhichactionbrc
mov [linemaxy], dx
mov [linemaxx], cx
mov cx, [xscreator+bx]
mov dx, [yscreator+bx]
mov [liney], dx
mov [linex], cx
mov al, [savecolorarr+bx]
mov [color], al
call hozline
add bx, 2
cmp bx, [currentline]
jl drawlinesbrc
checkwhichactionbrc:
call checkenterl
mov ax, 3      
int 33h 
test bx, 02h
jz leftbuttonpressedbrc
dec [bordercolor]
call changingbordercolor
leftbuttonpressedbrc:
test bx, 1
jz checkwhichactionbrc
inc [bordercolor]
call changingbordercolor

ret
endp changingbordercolor

proc changinglinescolor
call CloseFile
; Graphic mode
mov ax, 13h
int 10h
call setbackround
call borders
jmp drawlineslcb
startchanginglinescolor:
call CloseFile
mov [delaytimeval], 2
call delaytime
; Graphic mode
mov ax, 13h
int 10h
call setbackround
call borders
mov bx, 0
call updatelcp
mov bx, 100
call updatelcp
mov bx, 200
call updatelcp


drawlineslcb:
mov bx, [currentlevelc]
drawlineslc:
mov cx, [xmaxcreator+bx]
mov dx, [ymaxcreator+bx]
cmp cx, [xscreator+bx]
jle checkwhichactionlc
cmp dx, [yscreator+bx]
jle checkwhichactionlc
mov [linemaxy], dx
mov [linemaxx], cx
mov cx, [xscreator+bx]
mov dx, [yscreator+bx]
mov [liney], dx
mov [linex], cx
mov al, [savecolorarr+bx]
mov [color], al
call hozline
add bx, 2
cmp bx, [currentline]
jl drawlineslc
checkwhichactionlc:
call checkenterl
mov ax, 3      
int 33h 
test bx, 02h
jz leftbuttonpressedlc
mov al, [linescolor]
mov [lastcolor], al
dec [linescolor]
cmp [linescolor], 117
jne notenddec
dec [linescolor]
notenddec:
call startchanginglinescolor
leftbuttonpressedlc:
test bx, 1
jz checkwhichactionlc
mov al, [linescolor]
mov [lastcolor], al
inc [linescolor]
cmp [linescolor], 117
jne notendinc
inc [linescolor]
notendinc:
call startchanginglinescolor

ret
endp changinglinescolor

proc changeplayerplace

call CloseFile
mov [delaytimeval], 2
call delaytime
; Graphic mode
mov ax, 13h
int 10h
call setbackround
call borders
mov bx, 0
drawlinespc:
mov cx, [playerxposc]
mov dx, [playeryposc]
mov [color], 4
call printdot ;middeletop
dec cx
call printdot ;lefttop
inc dx 
call printdot ;left
inc dx 
call printdot;leftbottom
inc cx 
call printdot ;middelebottom
inc cx 
call printdot ;rightottom
dec dx 
call printdot ;right
dec dx 
call printdot ;righttop
cmp [starxposc], 500
je didntchoosespos2
mov cx, [starxposc]
mov dx, [staryposc]
call drawstar
didntchoosespos2:
mov cx, [xmaxcreator+bx]
mov dx, [ymaxcreator+bx]
cmp cx, [xscreator+bx]
jle showmousepc
cmp dx, [yscreator+bx]
jle showmousepc
mov [linemaxy], dx
mov [linemaxx], cx
mov cx, [xscreator+bx]
mov dx, [yscreator+bx]
mov [liney], dx
mov [linex], cx
mov al, [savecolorarr+bx]
mov [color], al
call hozline
add bx, 2
cmp bx, [currentline]
jl drawlinespc
showmousepc:
; Show mouse
mov ax,1h
int 33h
MouseLPpc :
mov ax,3h
int 33h
cmp bx, 01h ; check left mouse click
je pressedpc
call checkenterl
jmp MouseLPpc
pressedpc:
shr cx, 1
dec dx
mov [playerxposc], cx
mov [playeryposc], dx
call changeplayerplace
ret
endp changeplayerplace

proc changestarplace
call CloseFile
mov [delaytimeval], 2
call delaytime
; Graphic mode
mov ax, 13h
int 10h
call setbackround
call borders
mov bx, 0
drawlinessc:
mov cx, [playerxposc]
mov dx, [playeryposc]
mov [color], 4
call printdot ;middeletop
dec cx
call printdot ;lefttop
inc dx 
call printdot ;left
inc dx 
call printdot;leftbottom
inc cx 
call printdot ;middelebottom
inc cx 
call printdot ;rightottom
dec dx 
call printdot ;right
dec dx 
call printdot ;righttop
cmp [starxposc], 500
je didntchoosespos3
mov cx, [starxposc]
mov dx, [staryposc]
call drawstar
didntchoosespos3:
mov cx, [xmaxcreator+bx]
mov dx, [ymaxcreator+bx]
cmp cx, [xscreator+bx]
jle showmousesc
cmp dx, [yscreator+bx]
jle showmousesc
mov [linemaxy], dx
mov [linemaxx], cx
mov cx, [xscreator+bx]
mov dx, [yscreator+bx]
mov [liney], dx
mov [linex], cx
mov al, [savecolorarr+bx]
mov [color], al
call hozline
add bx, 2
cmp bx, [currentline]
jl drawlinessc
showmousesc:
; Show mouse
mov ax,1h
int 33h
MouseLPsc :
mov ax,3h
int 33h
cmp bx, 01h ; check left mouse click
je pressedsc
call checkenterl
jmp MouseLPsc
pressedsc:
shr cx, 1
dec dx
mov [starxposc], cx
mov [staryposc], dx
call changestarplace
ret
endp changestarplace

proc rightbuttonpressed

shr cx, 1
dec dx
mov bh,0h
mov ah,0Dh
int 10h 
cmp al, [backroundcolor]
jne pressedacube

didntpresscube:
mov bx, [currentline]
sub bx, 2
mov cx, [xmaxcreator+bx]
mov dx, [ymaxcreator+bx]
cmp cx, [xscreator+bx]
jg xscreatorisfine3
jmp checkwhichaction
xscreatorisfine3:
cmp dx, [yscreator+bx]
jg yscreatorisfine3
jmp checkwhichaction
yscreatorisfine3:
mov [linemaxy], dx
mov [linemaxx], cx
mov cx, [xscreator+bx]
mov dx, [yscreator+bx]
mov [liney], dx
mov [linex], cx
mov al, [backroundcolor]
mov [color], al
call hozline
mov [delaytimeval], 3
call delaytime
mov [xmaxcreator+bx], 0
mov [ymaxcreator+bx], 0
mov [xscreator+bx], 0
mov [yscreator+bx], 0
mov bx, 0
sub [currentline], 2
jmp checkwhichaction


pressedacube:
mov si, [currentlevelc]
check_line:
mov ax, [xscreator + si]
cmp cx, ax
jl loop_lines
mov ax, [xmaxcreator + si]
cmp cx, ax
jg loop_lines
mov ax, [yscreator + si]
cmp dx, ax
jl loop_lines
mov ax, [ymaxcreator + si]
cmp dx, ax
jg loop_lines

mov ax, [currentline]
sub ax, 2
cmp si, ax
jge didntpresscube

mov cx, [xmaxcreator+si]
mov dx, [ymaxcreator+si]
cmp cx, [xscreator+si]
jg xscreatorisfine4
jmp checkwhichaction
xscreatorisfine4:
cmp dx, [yscreator+si]
jg yscreatorisfine4
jmp checkwhichaction
yscreatorisfine4:
mov ax, 2  
int 33h    
mov [linemaxy], dx
mov [linemaxx], cx
mov cx, [xscreator+si]
mov dx, [yscreator+si]
mov [liney], dx
mov [linex], cx
mov al, [backroundcolor]
mov [color], al
call hozline
mov bx, [currentline]
sub bx, 2
mov cx, [xmaxcreator+bx]
mov dx, [ymaxcreator+bx]
mov [xmaxcreator+si], cx
mov [ymaxcreator+si], dx
mov cx, [xscreator+bx]
mov dx, [yscreator+bx]
mov [xscreator+si], cx
mov [yscreator+si], dx
mov al, [savecolorarr+bx]
mov [savecolorarr+si], al
mov bx, 0
mov si, 0

sub [currentline], 2
mov [delaytimeval], 2
call delaytime
mov ax, 1  
int 33h    
jmp checkwhichaction
loop_lines:
add si, 2
cmp si, [currentline]
je checkwhichaction
jmp check_line


ret
endp rightbuttonpressed

proc keyactionsguide
call CloseFile
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'c'
mov [filename+6], '0'
call callallimage
checkenterkg:
mov ah, 00h     
int 16h
cmp al, 13      
jne checkenterkg 
call CloseFile
ret
endp keyactionsguide

proc updatelcp
updatelc:
mov cx, [xmaxcreator+bx]
mov dx, [ymaxcreator+bx]
cmp cx, 0
je eupdatelc
cmp dx, 0
je eupdatelc
mov [linemaxy], dx
mov [linemaxx], cx
mov cx, [xscreator+bx]
mov dx, [yscreator+bx]
mov [liney], dx
mov [linex], cx
mov al, [savecolorarr+bx]
cmp al, 117
je itsend
mov al, [linescolor]
mov [savecolorarr+bx], al
itsend:
mov [color], al
add bx, 2
cmp bx, 300
jge drawlineslcb
jmp updatelc
eupdatelc:

ret
endp updatelcp

colorchangingexpl:
call CloseFile
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'c'
mov [filename+6], '8'
call callallimage
checkentercc:
mov ah, 00h     
int 16h
cmp al, 27
je backtochangec
cmp al, 13      
jne checkentercc   
call CloseFile
ret

placechangingexpl:
call CloseFile
; Graphic mode
mov ax, 13h
int 10h
mov [filename+5], 'c'
mov [filename+6], 'a'
call callallimage
checkentercp:
mov ah, 00h     
int 16h
cmp al, 27
je backtochangep
cmp al, 13      
jne checkentercp 
call CloseFile
ret

ret
endp levelcreator
proc screensprocs
proc callallimage
call OpenFile
call ReadHeader
call ReadPalette
call CopyPal
call CopyBitmap
ret
endp callallimage
proc OpenFile
; Open file
mov ah, 3Dh
xor al, al
mov dx, offset filename
int 21h
jc openerror
mov [filehandle], ax
ret
openerror :
mov dx, offset ErrorMsg
mov ah, 9h
int 21h
ret
endp OpenFile
proc ReadHeader
; Read BMP file header, 54 bytes
mov ah,3fh
mov bx, [filehandle]
mov cx,54
mov dx,offset Header
int 21h
ret
endp ReadHeader
proc ReadPalette
; Read BMP file color palette, 256 colors * 4 bytes (400h)
mov ah,3fh
mov cx,400h
mov dx,offset Palette
int 21h
ret
endp ReadPalette
proc CopyPal
; Copy the colors palette to the video memory
; The number of the first color should be sent to port 3C8h
; The palette is sent to port 3C9h
mov si,offset Palette
mov cx,256
mov dx,3C8h
mov al,0
; Copy starting color to port 3C8h
out dx,al
; Copy palette itself to port 3C9h
inc dx
PalLoop:
; Note: Colors in a BMP file are saved as BGR values rather than RGB .
mov al,[si+2] ; Get red value .
shr al,2 ; Max. is 255, but video palette maximal
; value is 63. Therefore dividing by 4.
out dx,al ; Send it .
mov al,[si+1] ; Get green value .
shr al,2
out dx,al ; Send it .
mov al,[si] ; Get blue value .
shr al,2
out dx,al ; Send it .
add si,4 ; Point to next color .
; (There is a null chr. after every color.)
loop PalLoop
ret
endp CopyPal
proc CopyBitmap

; BMP graphics are saved upside-down .
; Read the graphic line by line (200 lines in VGA format),
; displaying the lines from bottom to top.
mov ax, 0A000h
mov es, ax
mov cx,200
PrintBMPLoop :
push cx
; di = cx*320, point to the correct screen line
mov di,cx
shl cx,6
shl di,8
add di,cx
; Read one line
mov ah,3fh
mov cx,320
mov dx,offset ScrLine
int 21h
; Copy one line into video memory
cld ; Clear direction flag, for movsb
mov cx,320
mov si,offset ScrLine
rep movsb ; Copy line to the screen
 ;rep movsb is same as the following code :
 ;mov es:di, ds:si
 ;inc si
 ;inc di
 ;dec cx
;loop until cx=0
pop cx
loop PrintBMPLoop
ret
endp CopyBitmap
proc CloseFile
; Close file
mov ah, 3Eh
mov bx, [filehandle]
int 21h
ret
endp CloseFile
ret
endp screensprocs
proc generalprocs
proc setmousesnsitivity
mov ax, 0Fh       
mov cx, [mousexspeed]
mov dx, [mouseyspeed] 
int 33h   
ret
endp setmousesnsitivity
proc initmouse
; Initializes the mouse
mov ax,0h
int 33h
; Show mouse
mov ax,1h
int 33h
ret
endp initmouse
proc selctsound
; open speaker
in al, 61h
or al, 00000011b
out 61h, al
; send control word to change frequency
mov al, 0B6h 
out 43h, al
; play frequency 131Hz
mov ax, [noteE5]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
mov ax, [noteC5]
out 42h, al ; Sending lower byte
mov al, ah
out 42h, al ; Sending upper byte
mov [delaytimeval], 1
call delaytime
; close the speaker
in al, 61h
and al, 11111100b
out 61h, al
ret
endp selctsound
proc delaytime
; wait for first change in timer
mov ax, 40h
mov es, ax
mov ax, [Clock]
FirstTick :
cmp ax, [Clock]
je FirstTick
mov cx, [delaytimeval]
DelayLoop:
mov ax, [Clock]
Tick :
cmp ax, [Clock]
je Tick
loop DelayLoop
ret
endp delaytime
proc printdot
mov al, [color]
mov bh,0h
mov ah,0ch
int 10h
ret
endp printdot
ret
endp generalprocs
start :
mov ax, @data
mov ds, ax
call startscreens

; --------------------------
; Your code here
; --------------------------
exit :
mov ax, 4c00h
int 21h
END start
