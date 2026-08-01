# vim for the little ones

So, it happens in your life that you need to edit some configuration file, fill out a `git` commit comment, or write a similar note using `markdown` markup. And you have at your disposal the editor `vim` or `vi`, then open the terminal and enter `vimtutor` and do not read further this sheet. Scroll to the bottom if you just need to open, edit, close the file and forget.
**For basic interaction with this powerful editor, you need to know that...**

The editor has two modes -normal and input mode:

*`esc` puts you into command mode from input mode;
*`i` or `a` takes you from command mode to input mode.

**In input mode, you simply edit text as you would in any text editor.**
In command mode, you can open and create files, save them, change editor settings, execute commands in the terminal, split editor windows, turn the backlight on and off, change it, literally anything.

**Command mode is divided into:**

*keyboard, that is, after pressing `Esc` the entire keyboard turns into a set of hotkeys;
*command line mode, when you enter text commands that the editor executes.

**In keyboard mode you can press for example:**
*`dd` thereby deleting the line on which the cursor is;
*`u` rewind editing.

**Select, copy and paste commands:**

*`ctrl` + `v` or `shift` + `v` select text;
*`y` copy selected text;
*`p` paste selected text.

So, as described above, copy and paste only works inside `vim`.

You can insert external text by clicking on the mouse wheel. Or:

*`esc` -go to command mode;
*press `shift` + `"`, then press the `+` key separately, then `p` separately.

To copy to the system clipboard, do the same with `y` at the end:

*`esc` switch to command mode;
*Press `shift` and `"` together, then press the `+` key separately, then `y` separately

The symbol `"` is where the letter `e` is. According to the description, it is difficult, but in reality everything is easy to press.

**You need to switch to command line mode like this:**

*press `esc`;
*then press `shift` + `;` (where the letter `zh`)
**Now you can enter the commands:**

*`e file_name.txt` create and open for editing a new file `e` (from the word `edit`, edit -understanding how abbreviations are formed will help you memorize and recall commands);
*`set syntax=on` enable code highlighting;
*`set mouse=a` enable full mouse support;
*`vs` split window vertically;
*`sp` split window horizontally;
**Horizontal and vertical splitting of windows is very convenient if you need to write in one part of the file and read something at the other end or in another file.**

*`q` close the current file and/or the divided editing area.
*`ter` open a terminal directly in the editor.
*`!command` run the program directly from the editor, for example `!ls`.

**Running commands from the editor can be very useful, for example you need a file with a list of files in the current directory.**

*`esc`;
*`shift` + `;` (where the letter `zh` is)
*`e list.txt` or simply press the `e` key on your keyboard rather than typing the command `e list.txt`.
*`.!ls` paste the output of a command into a file on the line with the cursor **replacing the line**if it contained something.
*`4!ls` is the same as above, but you explicitly indicate the line to be inserted into, here in the fourth.
*`+!ls` is the same, but insert it on a line higher than where the cursor is.
*`-!ls` is the same, but on a line lower than where the cursor is.
*`%!ls` paste the output of the command into a file **overwriting the entire file**.
*`wq list.txt` or just `wq` if you previously specified the file name, and did not enter editing mode simply by pressing the `e` key

The `%` character indicates the currently edited buffer. Pressing the `e` key means entering the file editing mode without a name. Here `ls` is an example, it is fashionable to use `date`, `pwd` and any other non-interactive one. Can be combined as in the terminal

*`%!date && uptime && uname -a && echo "hello lor"`
**And the most important thing:**

*`w` save to current file;
*`w filename` save to a specific file;
*`wq` save file and exit;
*`q!` force exit without saving;

You can make any settings in your configuration file `~/.vimrc`

**For example:**

```
"That's how they write comments here
set syntax=on "turn on syntax highlighting
set mouse=a "enable full mouse support
set list "display special characters
set listchars=tab:►·,eol:·,trail: "tabs, end of line, spaces
"you can program and call other programs
"this is an example of a simple function
function Hello()
    exec('silent !notify-send hello little bugger')
endfunction

"Press F2 on the desktop there will be a notification
nnoremap <F2> :call Hello()<CR>
inoremap <F2> :call Hello()<CR>

"And much more 
```

If you edit `~/.vimrc` from Vim, reload the configuration to apply the change:

*`esc`
*`shift` + `;` (where the letter `zh` is)
*`so %` or `so ~/.vimrc`. `so` is short for `source` source code in our opinion.

Then press `F2` and a notification will pop up on the desktop. If it doesn’t pop up, it means `notify-send` is not installed (as homework, make it work). You can also save files using your hot buttons, for example, `F5`, if you are a gamer =) But for this you need to edit the example above, let this also be your homework.

**Everything is described in huge documentation:**

*`esc`;
*`shift` + `;` (where the letter `zh` is)
*`h` ;
*`Enter`;

...which is still difficult to read. At first, just look for how to do what you want on the Internet or through a search on this forum.

This is not just a configuration file, but an entire source file of the scripting programming language `VimL` and by describing the editor settings, you program it.  
[However, go to the Internet for this.](https://www.linux.org.ru/search.jsp?q=vimrc&range=ALL&interval=ALL&user=&_usertopic=on&sort=RELEVANCE&section=)
**Quick, basic search:**

*`esc`;
*`/`
*Next, enter what you want to find
*`Enter`

**Reset the backlight of what was found. For example**

*`esc`
*`/`
*type gibberish like `asdfsf` (stupid, but I use it because it's fast)
*`Enter`

*`esc`
*`shift` + `;`
*`noh`
*`Enter`

**Quickly jump to the desired line in the file.**

*`esc`
*`shift` + `;`
*`line number`
*`Enter`

**Fast, easy, text replacement.**

*`esc`
*`shift` + `;`
*`s/what-we-are-looking for/what-to-replace with/` replaces only one match and only in the line where the cursor is on.
    *`s/what-we-are-looking for/what-to-replace with/g` replaces all matches, but only in the line where the cursor is on.
    *`%s/what-we-are-looking for/what-to-replace-with/g` replaces all matches in the entire file.
*`Enter`
I described the basic features, although it still turned out to be a bit long, but they are already enough for a lot of things, I myself use `vim` on a regular basis, but rarely go beyond what I described above. I didn’t mention color schemes, thousands of plugins, etc., this is beyond the scope of a brief description.

***

**If you only occasionally need to edit configuration files on your server or router with vim pre-installed, then all you need to know is:**

*`vim /path/to/file/filename`;
*`i` enters edit mode. Change the text as you need;
*`esc` exits editing mode;
*`shift` + `;` call the command line, what below fits exactly into it;
*`wq` save and exit;
*`wq!` if there are no rights to save, then exit anyway (when you forgot `sudo` before `vim`);
*`q!` exit without saving (when you messed something up and got scared);

All!

***