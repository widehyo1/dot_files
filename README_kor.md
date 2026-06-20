# dot_files: 개인용 terminal workbench

이 저장소는 어디서나 바로 설치하는 범용 dotfiles 배포판이 아닙니다. 한 개발자가 반복하는 개발·운영·데이터 작업의 비용을 줄이기 위해 만든 Bash 진입점, Vim workflow, 작은 CLI 도구의 기록입니다. 경로와 alias에는 작성자의 WSL 환경과 일상 프로젝트가 의도적으로 반영되어 있으므로, 그대로 설치하기보다 필요한 패턴만 선택해 적용해야 합니다.

English version: [README.md](README.md)

## 개인 생산성 모델

반복 작업을 terminal 가까이에 둡니다. command가 존재할 때만 도구별 설정을 켜고, 한 번 해결한 변환은 script로 남기며, editor·script·input·output을 짧은 loop으로 연결합니다. `awk`, `jq`, `curl`은 각각 행/표 텍스트, 구조화된 JSON, HTTP input을 다루는 핵심 3신기입니다. 자주 만나는 file과 stdout 형태는 안정적인 경우가 많으므로, 범용 플랫폼보다 그 형태에 맞춘 최소 변환이 개인 생산성에 더 유효하다는 전제입니다.

| 저장소 경로 | 의도된 위치 | 역할 |
| --- | --- | --- |
| [`dot_config/bash`](https://github.com/widehyo1/dot_files/tree/main/dot_config/bash) | `~/.config/bash` | 계층화한 Bash 설정 |
| [`dot_cli/bin`](https://github.com/widehyo1/dot_files/tree/main/dot_cli/bin) | `~/.cli/bin` | `PATH`에 등록할 개인 command |
| [`dot_cli/awk`](https://github.com/widehyo1/dot_files/tree/main/dot_cli/awk) | `~/.cli/awk` | 텍스트·CSV·로그 변환 |
| [`dot_cli/jq`](https://github.com/widehyo1/dot_files/tree/main/dot_cli/jq) | `~/.cli/jq` | JSON·OpenAPI·HAR 변환 |
| [`dot_cli/curl`](https://github.com/widehyo1/dot_files/tree/main/dot_cli/curl) | `~/.cli/curl` | HTTP 요청 설정 |
| [`dot_vim`](https://github.com/widehyo1/dot_files/tree/main/dot_vim) | `~/.vim` | Vim-native UI와 workflow |

현재 설치 script는 Vim, Bash, `dot_cli`만 배포합니다. 다른 장비에서 쓰기 전 [`install.sh`](https://github.com/widehyo1/dot_files/blob/main/install.sh)와 [`install_with_stow.sh`](https://github.com/widehyo1/dot_files/blob/main/install_with_stow.sh)를 확인해야 합니다.

## 작업 인터페이스로서의 Vim

### Vim 8.1 popup window로 만든 UX

Vim 8.1 popup window API로 buffer menu, 파일/내용 검색, command 출력, jumplist, changelist view를 직접 구성합니다. custom filter가 `j`/`k`, `gg`/`G`, page movement, yank, Enter, `q`를 처리해 Vim다운 조작을 유지합니다.

- [`popup.vim`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/utils/popup.vim), [`popup_filter.vim`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/utils/popup_filter.vim)
- [`buffer.vim`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/utils/buffer.vim), [`custom/keymaps.vim`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/custom/keymaps.vim#L1-L46)

전체 설정이 plugin-free라는 뜻은 아닙니다. 이 UI workflow들이 기능마다 별도 plugin을 요구하지 않는다는 뜻입니다.

### Script + input + result loop

작업 단위는 **변환 script 편집 → 대표 input 편집 → 실행 → 결과 삽입 또는 복사 → 수정**입니다. mapping은 `~/script.awk`와 `~/temp.txt`, `~/script.jq`와 `~/temp.json`을 열고 실행합니다. curl도 request configuration과 body를 같은 방식으로 다룹니다.

- [`keymaps.vim`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/keymaps.vim#L66-L108)
- [`jq.vim`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/cli/jq.vim), [`curl.vim`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/cli/curl.vim)

중요한 것은 고정 도구 목록이 아니라 이 loop입니다. gnuplot, SQL, Python 등은 작성자의 입맛과 작업 방식에 맞을 때 같은 패턴으로 추가하면 됩니다.

### Vim–terminal PWD bridge

셸은 prompt 변경 때 directory를 알리고, Vim은 terminal directory를 기록합니다. terminal buffer의 `<leader>cd`는 그 위치를 Vim에 적용하며, terminal-open mode 하나는 Vim의 현재 directory를 shell로 보냅니다. buffer와 embedded terminal을 함께 쓸 때 문맥이 어긋나는 일을 줄입니다.

- [Bash signal emitter](https://github.com/widehyo1/dot_files/blob/main/dot_config/bash/cli/vimrc)
- [Vim terminal 구현](https://github.com/widehyo1/dot_files/blob/main/dot_vim/utils/terminal.vim), [terminal mapping](https://github.com/widehyo1/dot_files/blob/main/dot_vim/autocmd/terminal.vim)
- 상세 protocol과 `:help`: [Vim–terminal PWD bridge](docs/vim-terminal-pwd_kor.md)

일반 buffer의 `<leader>cd`는 current file directory로, `<leader>up`은 parent로 이동합니다: [`keymaps.vim`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/keymaps.vim#L110-L114). `<Space><Space><Space>`는 terminal-open 방식을 순환하고 `<C-d>`는 terminal을 새로 열거나, 하나만 있으면 재사용하고, 여러 terminal buffer가 있으면 popup selector를 표시합니다. terminal buffer에서는 이전 buffer로 돌아갑니다. Markdown `<Space>p`는 paste를 fenced code block으로 넣습니다: [`custom/keymaps.vim`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/custom/keymaps.vim#L20-L33), [`terminal.vim`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/utils/terminal.vim#L68-L114), [`markdown.vim`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/ftplugin/markdown.vim#L23-L32).

## Bash와 Unix 조합

[`commonrc`](https://github.com/widehyo1/dot_files/blob/main/dot_config/bash/commonrc)는 공통 설정, private/custom override, tool별 rc, machine별 shortcut을 분리합니다. `source_if_cmd()`는 command와 rc file이 모두 있을 때만 읽으므로 optional tool이 없는 vanilla machine에서도 shell이 시작됩니다.

`GITDIR`, `PLAYDIR`, `TODAY`는 workspace 위치를 모으고 `cd*` alias는 자주 가는 프로젝트로의 이동 비용을 낮춥니다: [`gitenv`](https://github.com/widehyo1/dot_files/blob/main/dot_config/bash/cli/gitenv), [`gitrc`](https://github.com/widehyo1/dot_files/blob/main/dot_config/bash/cli/gitrc), [`wsl11rc`](https://github.com/widehyo1/dot_files/blob/main/dot_config/bash/machine/wsl11rc). 재사용 가능한 개인 workflow는 `~/.cli/bin`에 등록하고 `PATH`에 포함합니다.

## 범용 dotfiles 대신 specialization

이 저장소는 portable default와 넓은 framework보다 명시적 path, daily note, WSL location, local project alias, 작은 Unix tool 조합을 선택합니다. 실제 workspace의 마찰은 낮지만 절대 경로, local DB, 외부 command, 개인 Python environment 때문에 그대로 설치하면 안 됩니다.

다른 개발자가 가져갈 수 있는 insight는 조건부 loading, 개인 command surface, stable input/output 형태를 위한 작은 tool, editor·shell·terminal을 하나의 workflow로 보는 관점입니다. 정말 개인적인 convention은 machine/custom layer에 격리해 안전하게 바꾸거나 무시할 수 있게 합니다.
