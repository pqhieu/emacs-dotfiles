;; init.el --- Quang-Hieu's personal Emacs configuration
;;
;; Copyright (C) 2015-2020
;;
;; Author: Quang-Hieu Pham <pqhieu1192@gmail.com>
;;
;; License:
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;; Reduce the frequency of garbage collection by making it happen on
;; each 100MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 100000000)
(setq file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)
;; Start Emacs package manager
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(setq package-enable-at-startup nil)
(package-initialize)
(add-to-list 'load-path "~/.emacs.d/lisp")
;; Set personal information
(setq user-full-name "Quang-Hieu Pham")
(setq user-mail-address "pqhieu1192@gmail.com")
;; Disable splash screen, toolbar and scrollbar
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(setq-default inhibit-splash-screen t)
(setq-default initial-scratch-message nil)
(setq default-frame-alist '((width . 80) (height . 40)))
;; Disable backup and auto-saving
(setq-default make-backup-files nil)
(setq-default backup-inhibited t)
(setq-default auto-save-default nil)
;; Disable blinking cursor
(blink-cursor-mode 0)
(setq-default cursor-type '(bar . 1))
;; Disable the annoying bell ring
(setq ring-bell-function 'ignore)
;; Set tab width and its behavior
(setq default-tab-width 4)
(setq-default indent-tabs-mode nil)
(setq-default fill-column 80)
(setq-default tab-always-indent 'complete)
(setq-default truncate-lines t)
;; Insert new line at EOF when save
(setq-default require-final-newline t)
(fset 'yes-or-no-p 'y-or-n-p)
;; Show line and column numbers in mode line
(line-number-mode 1)
(column-number-mode 1)
;; Revert buffers automatically
(global-auto-revert-mode 1)
;; Highlight corresponding parentheses
(show-paren-mode 1)
;; Handle camel case
(add-hook 'prog-mode-hook #'subword-mode)
;; Display date & time
(display-time-mode 1)
;; Disable all changes through customize
(setq custom-file (make-temp-file ""))
;; Set default font
(set-face-font 'default "iA Writer Mono S-15")
(set-face-font 'fixed-pitch "iA Writer Mono S-15")
(set-face-font 'variable-pitch "Concourse T3-17")
(setq-default line-spacing 0.1)
;; Check for use-package and install if needed
(unless (package-installed-p 'use-package)
  (message "`use-package` not found. Installing...")
  (package-refresh-contents)
  (package-install 'use-package))
;; Config use-package
(require 'use-package)
(require 'bind-key)
(setq use-package-verbose t)
;; Uniquify buffer names
(use-package uniquify
  :config
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-separator "/")
  ;; Rename after killing buffer
  (setq uniquify-after-kill-buffer-p t)
  ;; Ignore special buffers
  (setq uniquify-ignore-buffers-re "^\\*"))
;; Add recent files
(use-package recentf
  :config
  (setq recentf-max-saved-items 500)
  (setq recentf-max-menu-items 15))
;; Use Shift + arrow keys to switch between buffers
(use-package windmove
  :config
  (windmove-default-keybindings))
(use-package dired
  :config
  ;; Enable dired-jump
  (require 'dired-x)
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)
  (setq delete-by-moving-to-trash nil)
  (setq dired-dwim-target t)
  ;; Reuse current buffer by pressing 'a'
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
  (put 'dired-find-alternate-file 'disabled nil)
  (define-key dired-mode-map (kbd "^")
    (lambda () (interactive) (find-alternate-file "..")))
  ;; Remember to install coreutils on OSX
  (if (eq system-type 'darwin)
      (setq insert-directory-program "gls" dired-use-ls-dired t))
  (setq dired-listing-switches "-aFhlv --group-directories-first"))
(use-package org
  :config
  (setq org-ellipsis "⤵")
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")))
  (setq org-tags-column -77)
  ;; global effort estimate values
  (setq org-global-properties
        '(("Effort_ALL" .
           "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")))
  (setq org-columns-default-format
        "%50ITEM %2PRIORITY %10Effort(EFFORT){:} %10CLOCKSUM")
  (setq org-clock-into-drawer t)
  (setq org-clock-persist t)
  (org-clock-persistence-insinuate)
  (setq org-clock-out-when-done t)
  (setq org-pretty-entities t)
  (setq org-latex-create-formula-image-program 'dvisvgm)
  (setq org-preview-latex-image-directory "/tmp/ltximg")
  (setq org-fontify-whole-heading-line t)
  (setq org-fontify-done-headline t)
  (setq org-fontify-quote-and-verse-blocks t)
  (setq org-src-fontify-natively t)
  (setq org-deadline-warning-days 7)
  (setq org-src-preserve-indentation t))
(use-package org-agenda
  :bind ("C-c a" . org-agenda-show-all)
  :config
  (setq org-agenda-files '("~/Dropbox/agenda.org" "~/Dropbox/notes/dailies/"))
  (setq org-agenda-todo-ignore-scheduled (quote all))
  (setq org-agenda-todo-ignore-timestamp (quote all))
  (setq org-agenda-tags-column -77)
  ;; Do not show scheduled/deadline if done
  (setq org-agenda-skip-deadline-prewarning-if-scheduled t)
  (setq org-agenda-skip-deadline-if-done t)
  (setq org-agenda-skip-scheduled-if-done t)
  (setq org-agenda-hidden-separator "‌‌ ")
  (setq org-agenda-block-separator (string-to-char "-"))
  (setq org-agenda-custom-commands
        '(("o" "My agenda"
           ((tags "+TODO=\"TODO\"" ((org-agenda-overriding-header "❱ TODAY:\n")
                                    (org-agenda-todo-keyword-format "")))
            (agenda "" ((org-agenda-span 'week)
                        (org-agenda-todo-keyword-format "")
                        (org-agenda-overriding-header "❱ AGENDA:\n")
                        (org-agenda-current-time-string "◀┈┈┈┈┈┈┈┈ now")
                        (org-agenda-time-grid '((daily today) (0800 1200 1600 2000) "      " "┈┈┈┈┈┈┈┈┈┈┈┈┈"))))
            (tags "+TODO=\"NEXT\"" ((org-agenda-overriding-header "❱ TO DO:\n")
                                    (org-agenda-todo-keyword-format ""))))))))
(use-package org-bullets
  :ensure t
  :hook (org-mode . org-bullets-mode)
  :config
  (setq org-bullets-bullet-list '("" "" "" "" "" "" "" "")))
(use-package org-roam
  :ensure t
  :hook (after-init . org-roam-mode)
  :config
  (setq org-roam-directory "~/Dropbox/notes/")
  (setq org-roam-dailies-capture-templates
        '(("d" "daily" plain #'org-roam-capture--get-point ""
           :immediate-finish t
           :file-name "dailies/%<%Y%m%d>"
           :head "#+TITLE: %<%Y-%m-%d>\n#+STARTUP: content\n#+CATEGORY: DAILIES")))
  :bind (("C-c n l" . org-roam)
         ("C-c n f" . org-roam-find-file)
         ("C-c n g" . org-roam-graph)
         ("C-c n d" . org-roam-dailies-find-today)
         ("C-c n i" . org-roam-insert)
         ("C-c n I" . org-roam-insert-immediate)))
(use-package cc-mode
  :config
  (defun c-setup ()
    (c-set-offset 'innamespace [0])
    (c-set-offset 'inextern-lang [0]))
  (add-hook 'c-mode-common-hook 'c-setup)
  (add-hook 'c-mode-common-hook
            (lambda ()
              (add-hook (make-local-variable 'before-save-hook)
                        'clang-format-buffer)))
  (setq c-default-style "linux")
  (setq c-basic-offset 4))
(use-package whitespace
  :ensure t
  :config
  (setq whitespace-line-column 120) ;; limit line length
  (setq whitespace-style '(face tabs trailing lines-tail empty))
  ;; Delete trailing whitespace when save
  (add-hook 'before-save-hook #'whitespace-cleanup)
  (add-hook 'prog-mode-hook #'whitespace-mode))

;; Load shell environment variables
(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))
;; Load color theme
(use-package modus-operandi-theme
  :ensure t
  :config
  (setq modus-operandi-theme-bold-constructs t)
  (setq modus-operandi-theme-slanted-constructs nil)
  (setq modus-operandi-theme-faint-syntax t)
  (setq modus-operandi-theme-scale-headings nil)
  (setq modus-operandi-theme-variable-pitch-headings t)
  (setq modus-operandi-theme-fringes nil)
  (setq modus-operandi-theme-headings '((t . rainbow)))
  (load-theme 'modus-operandi t))
(use-package doom-modeline
  :ensure t
  :config
  (doom-modeline-mode 1)
  (setq doom-modeline-major-mode-icon t)
  (setq doom-modeline-minor-modes nil))
;; Ivy -- interactive interfact for completion
(use-package ivy
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-count-format "(%d/%d) ")
  ;; Add recent files into completion list
  (setq ivy-use-virtual-buffers t)
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-use-selectable-prompt t)
  (setq ivy-display-style 'fancy)
  (setq ivy-height 15))
(use-package swiper
  :ensure t
  :bind ("C-s" . swiper))
(use-package counsel
  :after ivy
  :ensure t
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-c l" . counsel-locate)
         ("C-c 8" . counsel-unicode-char)
         ("C-c s" . counsel-git-grep)
         ("C-h v" . counsel-describe-variable)
         ("C-h f" . counsel-describe-function)
         ("M-y" . counsel-yank-pop))
  :config
  (setq counsel-find-file-ignore-regexp "\\(?:^Icon?\\)"))
(use-package ivy-bibtex
  :ensure t
  :after ivy
  :bind ("C-c b" . ivy-bibtex)
  :config
  (setq bibtex-completion-bibliography '("~/Dropbox/main.bib"))
  (setq bibtex-completion-cite-prompt-for-optional-arguments nil)
  (setq bibtex-completion-format-citation-functions
        '((org-mode . bibtex-completion-format-citation-org-title-link-to-PDF)
          (latex-mode . bibtex-completion-format-citation-cite)
          (markdown-mode . bibtex-completion-format-citation-pandoc-citeproc)
          (default . bibtex-completion-format-citation-default)))
  (setq ivy-bibtex-default-action 'ivy-bibtex-insert-citation))
(use-package magit
  :ensure t
  :bind ("C-c g" . magit-status)
  :init
  ;; Have magit-status go full screen and quit to previous
  ;; configuration. Taken from
  ;; http://whattheemacsd.com/setup-magit.el-01.html#comment-748135498
  ;; and http://irreal.org/blog/?p=2253
  (defadvice magit-status (around magit-fullscreen activate)
    (window-configuration-to-register :magit-fullscreen)
    ad-do-it
    (delete-other-windows))
  (defadvice magit-quit-window (after magit-restore-screen activate)
    (jump-to-register :magit-fullscreen)))
(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0.5)
  (setq company-show-numbers t)
  (setq company-tooltip-limit 10)
  (setq company-minimum-prefix-length 2)
  (setq company-tooltip-align-annotations t)
  (setq company-tooltip-flip-when-above t)
  (global-company-mode t))
(use-package latex
  :defer t
  :ensure auctex
  :config
  (setq TeX-auto-save nil)
  (setq TeX-parse-self nil)
  (setq font-latex-script-display (quote (nil))))
(use-package clang-format :ensure t :defer t)
(use-package glsl-mode :ensure t :defer t)
(use-package yaml-mode :ensure t :defer t)
(use-package markdown-mode
  :ensure t
  :config
  (setq markdown-fontify-code-blocks-natively t))
(use-package beacon
  :ensure t
  :config
  (beacon-mode 1))
(use-package ledger-mode
  :ensure t
  :mode ("\\.ledger\\'")
  :config (setq ledger-clear-whole-transactions t))
(use-package highlight-indent-guides
  :ensure t
  :hook (prog-mode . highlight-indent-guides-mode)
  :config
  (setq highlight-indent-guides-method 'character)
  (setq highlight-indent-guides-responsive 'top))

(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))
(defun org-agenda-show-all ()
  "Show both agenda and todo list."
  (interactive)
  (org-agenda nil "o")
  (delete-other-windows))
(defun idle-garbage-collect ()
  "Reset gc-cons-threshold"
  (setq gc-cons-threshold 800000)
  (defun idle-garbage-collect ()
    (garbage-collect)))

(global-set-key (kbd "C-c \\") #'align-regexp) ;; align code based on regex
(global-set-key (kbd "C-c w") #'kill-other-buffers)
(global-set-key (kbd "C-c c") #'calendar)
(add-hook 'after-init-hook #'org-agenda-show-all)
(add-hook 'focus-out-hook #'idle-garbage-collect)
