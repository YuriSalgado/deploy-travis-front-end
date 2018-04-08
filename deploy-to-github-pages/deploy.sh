#!/bin/bash
set -e # termina o script com um c�digo diferente de 0 se alguma coisa falhar

# roda o script de build da nossa aplica��o
npm run build

# pull requests e commits para outras branches diferentes da master 
# n�o devem fazer o deploy, isso � opcional caso queira deletar as pr�ximas 6 linhas
# fique a vontade
SOURCE_BRANCH="master"

if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "$SOURCE_BRANCH" ]; then
    echo "Skipping deploy."
    exit 0
fi

# entre na pasta onde est� o build do seu projeto e inicie um novo reposit�rio git
cd build
git init

# inside this git repo we'll pretend to be a new user
# dentro desse reposit�rio n�s pretendemos ser um novo usu�rio
git config user.name "YuriSalgado"
git config user.email "yuri_salgadinho@hotmail.com"

# O primeiro e �nico commit do seu reposit�rio ter�
# todos os arquivos presentes e a mensagem do commit ser� "Deploy to GitHub Pages"
git add .
git commit -m "Deploy to GitHub Pages"

# For�ando o push do master para a branch gh-pages (Toda hist�ria anterior da branch
# gh-pages ser� perdido, pois vamos substitu�-lo.)  Redirecionamos qualquer sa�da para
# /dev/null para ocultar quaisquer dados de credenciais sens�veis que de outra forma possam ser expostos.
# tokens GH_TOKEN e GH_REF ser�o fornecidos como vari�veis de ambiente Travis CI
git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" master:gh-pages > /dev/null 2>&1