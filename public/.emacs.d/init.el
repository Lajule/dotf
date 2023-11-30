;;; package --- Summary

;;; {{ foo }}

;;; Commentary:

;;; Code:
(defvar gnutls-algorithm-priority)
(setq inhibit-splash-screen t
      visible-bell nil
      ring-bell-function 'ignore
      gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(setq-default frame-title-format '(buffer-file-name "%f" "%b")
	      truncate-lines t
              show-trailing-whitespace t)
(blink-cursor-mode -1)
(column-number-mode 1)
(delete-selection-mode 1)
(global-display-line-numbers-mode 1)
(line-number-mode 1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(show-paren-mode 1)
(tool-bar-mode -1)
(xterm-mouse-mode 1)
(xclip-mode 1)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes nil)
 '(package-selected-packages
   '(haskell-mode xclip erlang lua-mode restclient dockerfile-mode go-mode yaml-mode magit flycheck material-theme)))
;;(custom-set-faces
 ;;'(compilation-info ((t (:inherit success :foreground "#558b2f")))))
(load-theme 'material-light t)
;;(load-theme 'material t)
(global-flycheck-mode)
;;; init.el ends here
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
