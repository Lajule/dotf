(setopt inhibit-startup-screen t
        show-trailing-whitespace t
        truncate-lines t)

(blink-cursor-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(column-number-mode +1)
(delete-selection-mode +1)
(global-display-line-numbers-mode +1)
(line-number-mode +1)
(show-paren-mode +1)
(xterm-mouse-mode +1)

(global-flycheck-mode +1)
(xclip-mode +1)

(require 'org)
(require 'ob-C)
(require 'ob-shell)
(require 'ob-sql)

(custom-set-variables
 '(package-selected-packages '(magit flycheck xclip)))
