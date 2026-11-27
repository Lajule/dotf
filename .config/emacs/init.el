(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org") t)
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setopt use-package-always-ensure t)

(use-package emacs
  :ensure nil
  :init
  (setopt inhibit-startup-screen t
          show-trailing-whitespace t
          truncate-lines t)
  :config
  (dolist (mode '(blink-cursor-mode menu-bar-mode scroll-bar-mode tool-bar-mode))
    (funcall mode -1))
  (dolist (mode '(column-number-mode
                  delete-selection-mode
                  global-display-line-numbers-mode
                  show-paren-mode
                  xterm-mouse-mode))
    (funcall mode 1)))

(use-package org
  :ensure nil
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((C . t)
     (shell . t)
     (sql . t))))

(use-package magit
  :defer t)

(use-package flycheck
  :init (global-flycheck-mode 1))

(use-package xclip
  :init (xclip-mode 1))
