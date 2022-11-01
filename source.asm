.MODEL SMALL
.STACK 100h

data segment

    number_prompt db " Enter a number from 1-9 " ,10
    game_won db " Congratulations you won " ,10
    error_message db "Sorry the position is already taken" ,10

    array db 10 dup('_')
    input resq 1
    player resq 'X', 'O'

data ends

code segment
assume cs:code, ds:data

global start

    push_x:
        pop cx

        push ax
        push dx
        push di
        push cx
        ret

    pop_x:
        pop cx

        pop si
        pop di
        pop dx
        pop ax

        push cx
        ret

    ask_number:
        call push_x
        lea dx,number_prompt  
        mov ah,26 ; length of number_prompt
        int 21h 
        call pop_x
        ret

    print_won:
        call push_x
        lea dx,game_won  
        mov ah,26 ; length of game_won
        int 21h 
        call pop_x
        call exit

    print_error:
        call push_x
        lea dx,error_message  
        mov ah,36 ; length of error_message
        int 21h 
        call pop_x
        
        jmp play_game


     print_enter:
        call push_x
        mov ah,2
        mov dl,0ah
        int 21h
        mov dl,0dh
        int 21h
        call pop_x
        jmp loop_exit

    read_input:
        mov ah,1
        int 21h
        mov input, al

        mov ah,1
        int 21h

        mov bl,[input]
        sub al,'1'
        mul 8

        push ax
        mov ax,cl
        mov ch,2
        div ch
        mov ax, dx
        mov ch, 8
        mul ch

        mov ch, ax
        pop ax

        mov ah, [player+ch]
        mov al,[array+ax]
        cmp al,'X'
        
        je print_error
        cmp al,'O'
        je print_error
        mov [array+ax], ah

        ret

    print_grid:
        mov ah,array
        mov al,0

        print_grid_loop:
            lea dx,ah
            mov ah,36 ; length of game_won
            int 21h

            mov ax,al
            mov bh,3
            div bh
            cmp dx,0
            je print_enter

        loop_exit:
            add ah,8
            add al,1
            cmp al,8
            jle print_grid_loop
            ret

        check:
            mov ax,cl
            mov ah,2
            div ah
            cmp dx,0
            je check_for_X

            jmp check_for_O

        check_for_X:
            mov ah,[array+0]
            cmp ah,'X'
            je first_pos_check_X

            mov ah,[array+32]
            cmp ah,'X'
            je second_pos_check_X

            mov ah,[array+64]
            cmp ah,'X'
            je third_pos_check_X

            jmp check_exit

        first_pos_check_X:
            mov ah,[array+8]
            cmp ah,'X'
            je X_win_1

            mov ah,[array+32]
            cmp ah,'X'
            je X_win_2

            mov ah,[array+24]
            cmp ah,'X'
            je X_win_3

            jmp check_exit

        second_pos_check_X:
            mov ah,[array+8]
            cmp ah,'X'
            je X_win_4

            mov ah,[array+24]
            cmp ah, 'X'
            je X_win_5

            mov ah,[array+16]
            cmp ah, 'X'
            je X_win_3

            jmp check_exit

        third_pos_check_X:
            mov ah,[array+40]
            cmp ah, 'X'
            je X_win_6

            mov ah,[array+56]
            cmp ah,'X'
            je X_win_7

            jmp check_exit

        X_win_1:
            mov ah,[array+16]
            cmp ah,'X'
            je print_won

            jmp check_exit

        X_win_2:
            mov ah,[array+64]
            cmp ah, 'X'
            je print_won

            jmp check_exit

        X_win_3:
            mov ah,[array+48]
            cmp ah, 'X'
            je print_won

            jmp check_exit

        X_win_4:
            mov ah,[array+56]
            cmp ah, 'X'
            je print_won

            jmp check_exit

        X_win_5:
            mov ah,[array+40]
            cmp ah,'X'
            je print_won

            jmp check_exit

        X_win_6:
            mov ah,[array+16]
            cmp ah, 'X'
            je print_won

            jmp check_exit

        X_win_7:
            mov ah,[array+48]
            cmp ah, 'X'
            je print_won

            jmp check_exit

        check_for_O:
            mov ah,[array+0]
            cmp ah,'O'
            je first_pos_check_O

            mov ah,[array+32]
            cmp ah,'O'
            je second_pos_check_O

            mov ah,[array+64]
            cmp ah,'O'
            je third_pos_check_O

            jmp check_exit

        first_pos_check_O:
             mov ah,[array+8]
             cmp ah,'O'
             je O_win_1

             mov ah,[array+32]
             cmp ah,'O'
             je O_win_2

             mov ah,[array+24]
             cmp ah,'O'
             je O_win_3

             jmp check_exit

        second_pos_check_O:
             mov ah,[array+8]
             cmp ah,'O'
             je O_win_4

             mov ah,[array+24]
             cmp ah, 'O'
             je O_win_5

             mov ah,[array+16]
             cmp ah, 'O'
             je O_win_3

             jmp check_exit

        third_pos_check_O:
             mov ah,[array+40]
             cmp ah, 'O'
             je O_win_6

             mov ah,[array+56]
             cmp ah,'O'
             je O_win_7

             jmp check_exit

        O_win_1:
             mov ah,[array+16]
             cmp ah,'O'
             je print_won

            jmp check_exit

        O_win_2:
             mov ah,[array+64]
             cmp ah, 'O'
             je print_won

             jmp check_exit

        O_win_3:
              mov ah,[array+48]
              cmp ah, 'O'
              je print_won

              jmp check_exit

        O_win_4:
               mov ah,[array+56]
               cmp ah, 'O'
               je print_won

               jmp check_exit

        O_win_5:
               mov ah,[array+40]
               cmp ah,'O'
               je print_won

               jmp check_exit

        O_win_6:
               mov ah,[array+16]
               cmp ah, 'O'
               je print_won

               jmp check_exit

        O_win_7:
               mov ah,[array+48]
               cmp ah, 'O'
               je print_won

               jmp check_exit

    start:
       mov cl,0

        play_game:

            call ask_number
            call read_input


            print:
                call print_grid
                call check

            check_exit:
                add cl,1
                cmp cl,8
                jle play_game
    call check
    call exit


    exit:
        mov ah, 4ch
        int 21h

code ends


