(setq org-agenda-files (list "~/Dropbox/Documents/org/gtd.org"))

(setq org-agenda-show-log t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-start-on-weekday nil)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))



(provide 'org-setup)
