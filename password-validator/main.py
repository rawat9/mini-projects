# PASSWORD CHECKER IN TKINTER GUI 

from tkinter import *
import re

root = Tk()
root.geometry('500x300')
root.title('Password Checker')


def check():
    result = entry.get()
    x = True
    while x:
        if len(result) < 6 or len(result) > 8:
            break
        elif not re.search("[a-z]", result):
            break
        elif not re.search("[0-9]", result):
            break
        elif not re.search("[A-Z]", result):
            break
        elif not re.search("[?$%!@£]", result):
            break
        elif re.search(" ", result):
            break
        else:
            validate.config(text="Valid Password", fg='green', font=('', 18))
            x = False
            break

    if x:
        validate.config(text="Not a Valid Password", fg='red', font=('', 18))


validations = Label(root,
                    text="VALIDATIONS\n\n"
                    "1. Must be at least 6 characters but not more than 8\n"
                    "2. Must contain a mix of letters and numbers\n"
                    "3. Must have at least one capital letter\n"
                    "4. Cannot contain spaces\n"
                    "5. Must contain at least one of a set of special characters (?, $, %, !, @, £)\n",
                    justify=LEFT
                    )
validations.grid(row=0, column=0, pady=10)

password = Label(root, text='Enter the password:')
password.grid(row=1, column=0, padx=15, pady=10, sticky=W)

validate = Label(root, text='')
validate.grid(row=3, column=0, padx=5, pady=20)

entry = Entry(root, width=30, relief=GROOVE)
entry.grid(row=1, column=0, pady=10, sticky=E)

submit = Button(root, text='Submit', width=8, command=check)
submit.grid(row=2, column=0, pady=2)

root.mainloop()
