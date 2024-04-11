FROM archlinux

LABEL MAINTAINER="fengkx"
ARG ARCH_MIRROR_HOST=mirror.sjtu.edu.cn
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG USERNAME=dev

# Add archlinuxcn repository
RUN echo -e " \n\
	[archlinuxcn] \n\
	SigLevel = Optional TrustedOnly \n\
	Server = https://cdn.repo.archlinuxcn.org/\$arch \n\
	" >> /etc/pacman.conf

# Add multilib repository
RUN echo -e " \n\
	[multilib] \n\
	Include = /etc/pacman.d/mirrorlist \n\
	" >> /etc/pacman.conf

# Add multilib repository
RUN echo -e 'Server = https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist


# Set locale
RUN sed -i -e "s/#en_US\.UTF-8/en_US\.UTF-8/" /etc/locale.gen
RUN echo -e "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen

# Initialize local keyring
RUN pacman-key --init && pacman-key --populate archlinux
RUN pacman --noconfirm -Syyu


RUN pacman-key --lsign-key "farseerfc@archlinux.org"
RUN pacman -S --noconfirm archlinuxcn-keyring
RUN chmod 777 /etc/pacman.conf
RUN echo "%$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN pacman -Sy --noconfirm --needed \
	base-devel \
	clang \
	lld \
	xorg \
	awk \
	less \
	git \
	svn \
	less \
	openssh \
	python \
	python-pip \
	python-pipx \
	sed \
	shadow \
	sudo \
	tar \
	which \
	vim \
	ripgrep \
	wget \
	gettext \
	rustup \
	paru \
	archlinuxcn-keyring \
	&& pacman -Su --noconfirm \
	&& pacman-db-upgrade && update-ca-trust \
	&& pacman -Scc --noconfirm

RUN groupadd -r --gid $USER_GID $USERNAME && \
	useradd --uid $USER_UID --gid $USER_GID -r -m $USERNAME

RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
	chmod 0440 /etc/sudoers.d/$USERNAME

RUN mkdir -p /home/$USERNAME/.vscode-server/extensions \
	/home/$USERNAME/.vscode-server-insiders/extensions \
	&& chown -R $USERNAME:$USERNAME \
	/home/$USERNAME/.vscode-server \
	/home/$USERNAME/.vscode-server-insiders


USER $USERNAME
WORKDIR /tmp/
# RUN git clone https://aur.archlinux.org/paru.git && \
# 	cd paru && \
# 	makepkg -si --noconfirm

RUN rustup toolchain install nightly && \
	rustup default nightly

RUN curl -fsSL https://bina.egoist.dev/fengkx/lkdots | sh

RUN paru -Sy --noconfirm --needed \
	volta-bin \
	zsh \
	python \
	doko-rs \
	exa \
	neofetch \
	bat \
	htop \
	fd \
	libexif \
	fonts-tlwg \
	neovim \
	pyenv \
	diff-so-fancy \
	difftastic \
	fzf \
	lsof \
	xsel \
	ttf-meslo-nerd-font-powerlevel10k \
	rsync \
	thefuck \
	git-lfs \
	deno \
	&& paru -Scc --noconfirm

RUN paru -Sy --noconfirm --needed google-chrome && paru -Scc --noconfirm

ENV TERM=xterm-256color
WORKDIR /home/dev
