(setq inhibit-startup-screen t)

(setq-default truncate-lines t
              show-trailing-whitespace t)

(blink-cursor-mode -1)
(column-number-mode 1)
(delete-selection-mode 1)
(global-display-line-numbers-mode 1)
(xterm-mouse-mode 1)
(xclip-mode 1)

(require 'org)
(require 'ob-C)
(require 'ob-shell)
(require 'ob-sql)

(custom-set-variables
 '(package-selected-packages '(magit xclip)))
