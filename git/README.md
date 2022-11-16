This package provides a central git qube, named sys-git.
By default the qube has no netvm, but you can set one if you wish.

Some configuration is needed.

# Setting up a new repository

## sys-git
In sys-git, repositories are stored bare under /home/user/repos
First, prepare a repository:
```
mkdir repos/X
cd repos/X
git init --bare
```

## prepare client
Then prepare a qube by running:
`qubesctl --skip0-dom0 --targets=QUBE state.apply git.install_client`

## Work in the client
You can then use that repository as usual.
To push to sys-git you must first-  
`git push --set-upstream sg master`

After making more commits,
`git push `

# Working with an existing repository

## prepare client, if necessary
Prepare a qube by running:
`qubesctl --skip0-dom0 --targets=QUBE state.apply git.install_client`

## Clone the repository in the client
Configure git, as necessary.  
Open a terminal in the qube:
```
mkdir X
cd X
git init
add-remote sg
git pull sg master
```

## Work in the client
You can then use that repository as usual.
To push to sys-git you must first-  
`git push --set-upstream sg master`

After making more commits,  
`git push `




