;----------------------- hang-man for REPL Scheme ----------------------------; 

(define source-name "glossary.txt")

;; Side effect:
;; Strig-> IO([String])
;; Passed the path, open the file containing glossary
(define (read-words-from filename)
  (let* ((port (open-input-file filename))
         (res (read-word-list port '())))
    (close-input-port port)
    res))

;; Side effect
;; Fd -> [String] -> IO ([String])
;; Passed port and acumulator, return the all the words as strings
(define (read-word-list port acc)
  (let ((stuff (read port)))
    (if (eof-object? stuff)
        acc
        (read-word-list port
            (cons (symbol->string stuff) acc)))))

(define list-of-words (read-words-from source-name))


;--------------------------------------------------------------------------------;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  STATE OF THE GAME   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define glossary (map string->list list-of-words))       ; converts all the words into list
 
(define word-to-guess
  (list-ref glossary (random (length glossary))))        ; randomly choose word from glossary

(define hits 0)
(define plays 0)
(define failures 0)
(define total-failures 6)
(define total-hits (length word-to-guess))

(define partial-sol                                
  (string->list (make-string total-hits #\*)))           ; making string "*" of (length total-hits) = 9

(define (game-status)
  (begin
    (format "~a H:~a/~a F:~a/~a ~a ~a"          
            (list->string partial-sol)
            hits  total-hits
            failures  total-failures
            plays
            (if (and
                 (< hits total-hits)
                 (< failures total-failures))
                ""
                (string-append "GAME-OVER(" (list->string word-to-guess) ")")))))
          
;--------------------------------------------------------------------------------------------------------------;
;--------------------------------------------------------------------------------------------------------------'
; PURELY FUNCTIONAL --> | occurrences - SOLVED | indices - SOLVED | noOfHits - SOLVED | replace-indices - SOLVED
;--------------------------------------------------------------------------------------------------------------'

; 1. Function: occurrences ; Parameters: word, char
(define (occurrences word char)
  (cond
    ;; base case
    [(empty? word) 0]                                                ; check if the list (word) is empty?
    [(equal? (car word) char) (+ 1 (occurrences (cdr word) char))]   ; increment the counter by calling the function recursively for the (rest list)                                
    ;; recursive case
    [else
     (occurrences (cdr word) char)]))                                ; otherwise repeat the process until the base case is met (termination)
 

; 2. Function: indices ; Parameters: word, char
(define (indices word char)
  (let temp-indices ([word word][char char][counter 0])
  (cond
    ;; Return word if empty
    [(null? word) word] ;; Base Case
    
    ;; if its equal to counter then, put counter at the front of list and recursion until list is empty
    [(equal? (car word) char)(cons counter (temp-indices (cdr word) char (+ 1 counter)))]
    
    ;; if its not equal then, shorten list and recurse until list is empty
    [(temp-indices (cdr word) char (+ 1 counter))])))


; 3. Function: noOfHits | Parameter: hidden
(define (noOfHits hidden)
  (cond
    [(null? hidden) 0] ;; base case 
    [(not (eq? '#\* (car hidden))) (+ 1 (noOfHits (cdr hidden)))] ; if the (car hidden) is not equal to '*' \
    [else                                                         ; increment the counter by calling the function recursively for the (rest list)
     (noOfHits (cdr hidden))]))                                   ; otherwise repeat the process until the base case is met (termination)


; 4. Function: replace-indices | Parameters: word, idx, new
(define (replace-indices word index new)
  (let temp-repindices ([word word][index index][new new][order-lst 0])
  (cond
    ;; If index is empty, return word
    [(null? index) word] ;; Base Base
    
    ;; If car indext = order-lst, + 1 order-lst, cdr word, cdr index, put new infront and recurse
    [(equal? (car index) order-lst)(cons new (temp-repindices (cdr word) (cdr index) new (+ 1 order-lst)))]
    [else
     (cons (car word) (temp-repindices (cdr word) index new (+ 1 order-lst)))])))


;-----------------------------------------------------------------------
;-----------------------------------------------------------------------'
; Side effects  --> | restart - SOLVED | guess - SOLVED | solve | SOLVED        
;-----------------------------------------------------------------------'

; 1. Side-Effect Function: restart  
(define (restart)
  (begin
    (set! hits 0)                                                                  ; reset hits to 0
    (set! failures 0)                                                              ; reset failures to 0
    (set! plays 0)                                                                 ; reset plays to 0
    (set! partial-sol (string->list (make-string total-hits #\*)))                 ; reset partial-sol to list of "*"
    (game-status)))                                                                ; return game-status



; 2. Side-Effect Function: guess | Parameter: char 
(define (guess char)
  (begin
    (set! plays (+ plays 1))                                                       ; increase the number of plays by 1
    (if (member char partial-sol)                                                  ; if the char is already been guessed, don't increment the hits
        (and (set! hits (- hits 1)) (display "WARNING: You've already guess this char ")))

    ; updates the partially guessed word, replacing any occurrences at indices with the given char
    (set! partial-sol (replace-indices partial-sol (indices word-to-guess char) char))

    (set! hits (noOfHits partial-sol))                                             ; updating hits to noOfHits of partial-sol   
    (cond
      [(= (occurrences word-to-guess char) 0)                                      ; increase failures if the set of occurrences \
       (set! failures (+ failures 1))])                                            ; of given char is 0
    
    (game-status)))                                                                ; returns game-status
            


; 3. Side-Effect Function: solve | Parameter: word
(define (solve word)
  (begin
    (for-each                  
     (lambda (a b)                                                       ; λ (a b) for 2 arguments : word-to-guess (string->list word)
       (if (equal? a b)                                                  ; if both the args are equal > set hits = total-hits AND partial-sol to the given word
           (and (set! hits total-hits) (set! partial-sol (string->list word))))) 
      word-to-guess (string->list word))                                 ; the 2 arguments
    (set! plays (+ plays (string-length word)))                          ; increase plays by (length word)
    (game-status)))


;--------------------------------------------------------------------------------------------;
;--------------------------------------------------------------------------------------------
; EXTRA - F3 --> | words-containing - SOLVED | words-containing-ext - SOLVED | sieve - SOLVED
;--------------------------------------------------------------------------------------------

;; p: all-words as list of list of char
(define (words-containing all-words char)
  (cond
    [(empty? all-words) empty]                                        ; check if the list (all-words) is empty
    [(member char (car all-words))                                    ; check if char is the member of list inside list of chars
     (cons (car all-words) (words-containing (cdr all-words) char))]  ; cons the rest list with the (first all-words)
    [else (words-containing (cdr all-words) char)]))                  ; recursively call the function, for (rest list)
  


; 2. Function: words-containing-ext | Parameters: all-words, chars | w = all-words, c = chars
(define (words-containing-ext all-words chars)
  (foldl                                                         ; traversing from L - R
   (λ (c w) (words-containing w c)) all-words chars              ; applies the procedure with all corresponding elements of the list
  ))                                                             



; 3. Function: sieve | Parameter: chars
(define (sieve chars)
  (begin
    (map list->string (words-containing-ext glossary chars))    ; mapping the procedure to every word in the glossary
  )
)


;----------------;
;----------------;
;    Testing     ;
;----------------;

(require rackunit rackunit/gui)  ; GUI test runner

(define (testing)                ; for running tests, type (testing) on console
  (test/gui 
   (test-suite                   ; test-suite? a group of test cases. 
    "all tests"

    ; using basic-checks on all the functions 
    (test-suite
     "F1 Utility Functions"
     (test-case "occurrences" (check-equal? (occurrences '(#\a #\b #\b) #\b) 2))    
     (test-case "indices" (check-equal? (indices '(#\a #\b #\b) #\b) '(1 2)))
     (test-case "noOfHits" (check-equal? (noOfHits '(#\a #\* #\*)) 1))
     (test-case "replace-indices" (check-equal? (replace-indices '(#\a #\* #\*) '(1 2) #\b) '(#\a #\b #\b))))

    (test-suite
     "F2 Game Functionality"
     (test-case "restart" (check-equal? (substring (restart) 10 23) "H:0/9 F:0/6 0"))  
     (test-case "guess" (check-not-eq? (guess '#\z) (restart)))   
     (test-case "solve" (check-true (string? (solve (list->string word-to-guess))))))

    (test-suite     
     "F3 Game Hints"
     (test-case "words-containing" (check-equal? (words-containing '((#\b #\u #\s) (#\b #\a #\r)) #\r) '((#\b #\a #\r))))
     (test-case "words-containing-ext" (check-equal? (words-containing-ext '((#\c #\a #\r) (#\b #\a #\r)) '(#\a #\r))
                                                     '((#\c #\a #\r) (#\b #\a #\r))))
     (test-case "sieve" (check-equal? (sieve '(#\a #\y #\l)) '("callosity" "callidity")))))))
