;turning {
T25:									;starting standing right, turning left
;dw !TNone,$0280,$001A					;auto jump if holding (technically pressing) jump and the opposite direction
dw !TJump,!TNone,$004C
dw !TNone,!TLeft,$0025
dw !TEnd

T26:									;starting standing left, turning right
;dw !TNone,$0180,$0019					;auto jump if holding (technically pressing) jump and the opposite direction
dw !TJump,!TNone,$004B
dw !TNone,!TRight,$0026
dw !TEnd

;hurt {
T4F:									;Hurt roll back, moving right/facing left
;%t_1(!TDown, !TRun, $0038)
dw !TNone,$0280,$0052
; --- modified ---
dw !TNone,!TJump,$004F					;normally you have to hold run + jump to continue damage boosting, now you only have to hold jump
; ----------------
dw !TEnd

T50:									;Hurt roll back, moving left/facing right
;%t_1(!TDown, !TRun, $0037)
; --- modified ---
%t_2(!TNone, !TRight, !TJump, $00, $51)	;was originally jump + left for both T4F and T50, but T50 is moving left, so holding right should stop her ($0050)
dw !TNone,!TJump,$0050					;same change as T4F
; ----------------
dw !TEnd

;walljump {
T83:									;Walljump right
dw !TDown,!TNone,$0037
dw !TNone,!TLeft,$001A
dw !TNone,!TAimU,$0069
dw !TNone,!TAimD,$006B
dw !TFire,!TNone,$0013					;this lets you hold charge while walljumping, but still fire by pressing fire
dw !TNone,!TJump,$0083
dw !TEnd

T84:									;Walljump left
dw !TDown,!TNone,$0038
dw !TNone,!TRight,$0019
dw !TNone,!TAimU,$006A
dw !TNone,!TAimD,$006C
dw !TFire,!TNone,$0014					;this lets you hold charge while walljumping, but still fire by pressing fire
dw !TNone,!TJump,$0084
dw !TEnd
}