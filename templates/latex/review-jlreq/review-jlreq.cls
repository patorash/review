% Re:VIEW + jlreq
% Copyright 2018 Kenshi Muto <kmuto@debian.org>
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{review-jlreq}[2018/4/28]
\LoadClassWithOptions{jlreq}

% クラスオプション
% TODO:
% hanmen(boolean)→版面表示。便利なので入れたい
% draft(boolean)→これはjlreqでいけるはず?
% mentuke(boolean)→なくてもよいか
% cameraready=pdf/print(string)→設定が難しい
% paper=a5+3mm→jlreq-trimmarksのオプションとだいぶ違う
% toc:break-before=right, index:break-before=both→完全白ページが問題になる同人誌だと怖そう
% 白ページでもノンブルを打つ という設定(とpagestyle)がほしいか
% 扉画像の指定はreviewmacroのパラメータのほうでやらせるべきか
%
% <<review-jlreq独自>>
% tombo:bleed(数値+単位) : 裁ち落とし幅。デフォルト3mm
% tombo:color(\colorの色またはcmykの組み合わせ) : トンボの色。デフォルトcmyk(全プレート)
% tombo:paper(トンボ入り紙面サイズ) : トンボを付けたときのサイズ。デフォルトは現在のサイズ+2インチ。a4, b5(ここでのbはJISサイズ)などを指定可能。{width, height}も指定可能…だが今はダメ(FIXME)
% tombo:show({}指定) : {trimmarks,banner,digital}からの組み合わせ。trimmarksはトンボマーク表示、bannerはファイル名+日付、digitalはデジタルトンボ情報を入れる (FIXME、{}がまだとれない)
% hyperrefの設定もやったほうがよさそう

% FIXME: Unused global option [book] が出るの嫌だ(実際はchapterに必要)
% \setkeyしたら別の影響が出る
\DeclareOption{book}{\OptionNotUsed}
\DeclareOption{dvipdfmx}{\OptionNotUsed}

% documentclassでのkeyval使用定義
\DeclareOption*{\rjreq@setkey}
\def\rjreq@setkey{\expandafter\@rjreq@setkey\expandafter{\CurrentOption}}
\def\@rjreq@setkey{\setkeys{rjreq}}

% トンボ有効化時設定
\newif\if@review@jlreq@tombo
\@review@jlreq@tombofalse
\DeclareOption{tombo}{\@review@jlreq@tombotrue}
% トンボの詳細設定
%% パッケージオプション系。初期値は定義しないことにしてundefined評価でオプション追加するかどうかを判定させる
%\def\@review@jkreq@tombo@paper{a4}
%\def\@review@jkreq@tombo@show{trimmarks,banner,digital}

%% \jlreqtrimmarkssetup設定系
\def\@review@jlreq@tombo@banner{\jobname\space(\number\year-\two@digits\month-\two@digits\day\space\two@digits\hour:\two@digits\minute)}% バナー(動的にはできない)
\def\@review@jlreq@tombo@bleed{3mm}% 裁ち落とし幅
\def\@review@jlreq@tombo@color{cmyk}% トンボの色。cmykはCMYK全プレートで100%

% documentoptionからの取り込み
\define@key{rjreq}{tombo:paper}{\def\@review@jlreq@tombo@paper{#1}}
\define@key{rjreq}{tombo:show}{\def\@review@jlreq@tombo@show{#1}}% FIXME:これは{}を取るのでダメ
\define@key{rjreq}{tombo:banner}{\def\@review@jlreq@tombo@banner{#1}}
\define@key{rjreq}{tombo:bleed}{\def\@review@jlreq@tombo@bleed{#1}}
\define@key{rjreq}{tombo:color}{\def\@review@jlreq@tombo@color{#1}}

\ExecuteOptions{}% 初期有効化するもの
\ProcessOptions\relax
% パッケージオプションの適用
\ifdefined\@review@jlreq@tombo@paper
  \PassOptionsToPackage{trimmarks_paper=\@review@jlreq@tombo@paper}{jlreq-trimmarks}
\fi
\ifdefined\@review@jlreq@tombo@show% FIXME:これは{}を取るのでダメ
  \PassOptionsToPackage{show=\@review@jlreq@tombo@show}{jlreq-trimmarks}
\fi

%% fixes to LaTeX2e
\RequirePackage{fix-cm,exscale}
\IfFileExists{latexrelease.sty}{}{\RequirePackage{fixltx2e}}
\IfFileExists{platexrelease.sty}{%% is bundled in TL16 or higher release version

\PassOptionsToPackage{nosetpagesize}{graphicx}%%for TL16 or higher version
}{}

% トンボ指定
\if@review@jlreq@tombo
% FIXME:パッケージオプションのtrimmarks_paper, showをどう渡すか
\RequirePackage{jlreq-trimmarks}
\fi

\def\maxwidth{%
  \ifdim\Gin@nat@width>\linewidth
    % \linewidth
    \dimexpr\linewidth - 1\p@ - 3mm\relax
  \else
    % \Gin@nat@width
    \dimexpr\Gin@nat@width - 1\p@ - 3mm\relax
  \fi
}

% エンジンとドライバの情報。jlreq-trimmarksが定義されていればそっちから持ってくる。
% 定義されていなければjlreqから持ってくる
\def\review@jlreq@driver@luatex{luatex}
\def\review@jlreq@engine{}
\def\review@jlreq@driver{}
\ifdefined\jlreq@trimmarks@engine
  \ifx l\jlreq@trimmarks@engine\def\review@jlreq@engine{lualatex}\fi
  \ifx u\jlreq@trimmarks@engine\def\review@jlreq@engine{uplatex}\fi
  \ifx p\jlreq@trimmarks@engine\def\review@jlreq@engine{platex}\fi
\else% jlreqから持ってくる
  \ifx l\jlreq@engine\def\review@jlreq@engine{lualatex}\fi
  \ifx u\jlreq@engine\def\review@jlreq@engine{uplatex}\fi
  \ifx p\jlreq@engine\def\review@jlreq@engine{platex}\fi
\fi
\ifdefined\jlreq@trimmarks@driver
  \ifx f\jlreq@trimmarks@driver\def\review@jlreq@driver{dvipdfmx}\fi
  \ifx s\jlreq@trimmarks@driver\def\review@jlreq@driver{dvips}\fi
  \ifx o\jlreq@trimmarks@driver\def\review@jlreq@driver{dviout}\fi
\else% jlreqから持ってくる
  \ifx l\jlreq@engine
    \def\review@jlreq@driver{luatex}
  \else
    \def\review@jlreq@driver{dvipdfmx}
  \fi
\fi

\RequirePackage[\review@jlreq@driver]{graphicx}
\RequirePackage[\review@jlreq@driver,table]{xcolor}

% jlreq-trimmarksへ追加オプション渡し(事前にxcolorが必要)
% trimmarks_widthを指定したくなるケースはまずないとしてよいか…bannerもどうするか
\if@review@jlreq@tombo
  \jlreqtrimmarkssetup{bleed_margin=\@review@jlreq@tombo@bleed,color=\@review@jlreq@tombo@color,banner=\@review@jlreq@tombo@banner}% デフォルトは3mm, cmyk
\fi

% TODO:documentoptionである程度指定したい
\RequirePackage[\review@jlreq@driver, bookmarks=true, bookmarksnumbered=true,
  % colorlinks=true,
  hidelinks,
setpagesize=false]{hyperref}[2016/06/24 v6.83q]
\RequirePackage[T1]{fontenc}
\RequirePackage{textcomp}%T1/TS1
\RequirePackage{lmodern}%\ttdefault: lmtt
\def\review@jlreq@driver@luatex{luatex}
\ifx\review@jlreq@driver\review@jlreq@driver@luatex\else
\RequirePackage[\review@jlreq@driver]{pxjahyper}[2012/05/27 v0.2]
\fi
\RequirePackage{tikz}
\usetikzlibrary{calc}
\RequirePackage{multirow}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
