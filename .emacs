;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; File name: ` ~/.emacs '
;;; ---------------------
;;;
;;; If you need your own personal ~/.emacs
;;; please make a copy of this file
;;; an placein your changes and/or extension.
;;;
;;; Copyright (c) 1997-2002 SuSE Gmbh Nuernberg, Germany.
;;;
;;; Author: Werner Fink, <feedback@suse.de> 1997,98,99,2002
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Test of Emacs derivates
;;; -----------------------
(if (string-match "XEmacs\\|Lucid" emacs-version)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; XEmacs
  ;;; ------
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    (progn
        (if (file-readable-p "~/.xemacs/init.el")
            (load "~/.xemacs/init.el" nil t))
        )
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; GNU-Emacs
  ;;; ---------
  ;;; load ~/.gnu-emacs or, if not exists /etc/skel/.gnu-emacs
  ;;; For a description and the settings see /etc/skel/.gnu-emacs
  ;;;   ... for your private ~/.gnu-emacs your are on your one.
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    (if (file-readable-p "~/.gnu-emacs")
        (load "~/.gnu-emacs" nil t)
        (if (file-readable-p "/etc/skel/.gnu-emacs")
            (load "/etc/skel/.gnu-emacs" nil t)))

    ;; Custom Settings
    ;; ===============
    ;; To avoid any trouble with the customization system of GNU emacs
    ;; we set the default file ~/.gnu-emacs-custom
    (setq custom-file "~/.gnu-emacs-custom")
    (load "~/.gnu-emacs-custom" t t)
;;;
    )
;;;

                                        ;disable backup
(setq backup-inhibited t)
                                        ;disable auto save
(setq auto-save-default nil)

;; Linum plugin
(require 'linum) ;; вызвать Linum
(line-number-mode   t) ;; показать номер строки в mode-line
(global-linum-mode  t) ;; показывать номера строк во всех буферах
(column-number-mode t) ;; показать номер столбца в mode-line
(setq linum-format " %4d │ ") ;; задаем формат нумерации строк

;; Fringe settings
;;(fringe-mode '(8 . 0)) ;; органичиталь текста только слева
(setq-default indicate-empty-lines t) ;; отсутствие строки выделить глифами рядом с полосой с номером строки
(setq-default indicate-buffer-boundaries 'left) ;; индикация только слева

;; Display file size/time in mode-line
(setq display-time-24hr-format t) ;; 24-часовой временной формат в mode-line
(display-time-mode             t) ;; показывать часы в mode-line
(size-indication-mode          t) ;; размер файла в %-ах

;; Buffer Selection and ibuffer settings
(require 'bs)
(require 'ibuffer)
(defalias 'list-buffers 'ibuffer) ;; отдельный список буферов при нажатии C-x C-b
(global-set-key (kbd "<f2>") 'bs-show) ;; запуск buffer selection кнопкой F2

;; Indent settings
(setq-default indent-tabs-mode nil) ;; отключить возможность ставить отступы TAB'ом
(setq-default tab-width          4) ;; ширина табуляции - 4 пробельных символа
(setq-default c-basic-offset     4)
(setq-default standart-indent    4) ;; стандартная ширина отступа - 4 пробельных символа
(setq-default lisp-body-indent   4) ;; сдвигать Lisp-выражения на 4 пробельных символа
(global-set-key (kbd "RET") 'newline-and-indent) ;; при нажатии Enter перевести каретку и сделать отступ
(setq lisp-indent-function  'common-lisp-indent-function)

;; Scrolling settings
(setq scroll-step               1) ;; вверх-вниз по 1 строке
(setq scroll-margin            10) ;; сдвигать буфер верх/вниз когда курсор в 10 шагах от верхней/нижней границы
(setq scroll-conservatively 10000)

;; Short messages
(defalias 'yes-or-no-p 'y-or-n-p)

;; Clipboard settings
(setq x-select-enable-clipboard t)

;; End of file newlines
(setq require-final-newline    t) ;; добавить новую пустую строку в конец файла при сохранении
(setq next-line-add-newlines nil) ;; не добавлять новую строку в конец при смещении
;; курсора  стрелками
;; Easy transition between buffers: M-arrow-keys
(if (equal nil (equal major-mode 'org-mode))
    (windmove-default-keybindings 'meta))

(global-set-key  (kbd "S-M-<up>") 'enlarge-window)
(global-set-key  (kbd "S-M-<down>") 'shrink-window)
(global-set-key  (kbd "S-M-<right>") 'enlarge-window-horizontally)
(global-set-key  (kbd "S-M-<left>") 'shrink-window-horizontally)

; Delete trailing whitespaces, format buffer and untabify when save buffer
(defun format-current-buffer()
    (indent-region (point-min) (point-max)))
(defun untabify-current-buffer()
    (if (not indent-tabs-mode)
        (untabify (point-min) (point-max)))
    nil)
;(add-to-list 'write-file-functions 'format-current-buffer)
;(add-to-list 'write-file-functions 'untabify-current-buffer)
;(add-to-list 'write-file-functions 'delete-trailing-whitespace)
;(load-theme 'whiteboard)


;; ------------------ MELPA
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize) ;; You might already have this line

(setq path-to-ctags "/usr/bin/etags") ;; <- your ctags path here

(defun create-tags (dir-name)
    "Create tags file."
    (interactive "DDirectory: ")
    (shell-command
         (format "etags -f %s -e -R %s" path-to-ctags (directory-file-name dir-name))
    )
)

(setq load-home-init-file t) ; don't load init file from ~/.xemacs/init.el

;; -- sunrise commander
;;(add-to-list 'load-path "~/.emacs.d/local/sunrise-commander")
;;(require 'sunrise)


;; -- clang-format
(require 'clang-format)
(setq clang-format-style "file")
(global-auto-revert-mode t)  ;; for auto-reloading file on change
