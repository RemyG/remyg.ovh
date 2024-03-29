---
layout: rg-post
title: "Using multiple SSH keys concurrently"
update-date: 2023-08-22T12:00:0+02:00
avatar:
category: System
tags: 
  - SSH
  - Git
---

**Updated** - Added a third solution, on a repository basis.

When using multiple GitLab accounts (e.g. private account and work account) on the same computer, you can't use the same SSH key for both. This can become problematic when Git has to decide which key to use to communicate with the distant repository.

<!--more-->

There are 3 main solutions to this problem. You can specify the SSH key to use:

* based on the distant repository host,
* based on the project path,
* or locally for a specific repository.

The following examples assume that you have the 2 SSH keys `~/.ssh/id_rsa_perso` and `~/.ssh/id_rsa_work`.

## Host-based configuration

The first solution requires you to change the URL of the repository when cloning it.

For example, when cloning a work project located at `https://gitlab.com/my-org/my-project`, the command would be:

```
git clone git@work-gitlab.com:my-org/my-project.git
```

and for a personal project located at `https://gitlab.com/me/my-project`:

```
git clone git@home-gitlab.com:me/my-project.git
```

Then, in the SSH configuration file (`~/.ssh/config`):

```
# Personal account:
Host home-gitlab.com
  HostName gitlab.com
  User git
  IdentityFile ~/.ssh/id_rsa_perso
  PreferredAuthentications publickey
  PasswordAuthentication no
  IdentitiesOnly yes

# Work account:
Host work-gitlab.com
  HostName gitlab.com
  User git
  IdentityFile ~/.ssh/id_rsa_work
  PreferredAuthentications publickey
  PasswordAuthentication no
  IdentitiesOnly yes
```

This works fine, but it requires you to always remember to modify the project URL when cloning it.

## Path-based configuration

Since Git 2.13, a conditional include is available in the local Git configuration. This means that you can include a specific configuration file when your current path matches a specific filter.

For example, if your work projects are located in `~/work/sources` and your personal project in `~/perso/sources`, you can create a Git work-related configuration file `~/.gitconfig-work`:

```
[user]
    email = "your.email@work.com"
[core]
    sshCommand = "ssh -i ~/.ssh/id_rsa_work"
```

and a personal configuration file `~/.gitconfig-perso`:

```
[user]
    email = "your.email@home.com"
[core]
    sshCommand = "ssh -i ~/.ssh/id_rsa_perso"
```

Now you only need to include the correct configuration file based on your path, by modifying the global `~/.gitconfig` file and including:

```
[includeIf "gitdir:~/work/sources/"]
    path = .gitconfig-work
[includeIf "gitdir:~/perso/sources/"]
    path = .gitconfig-perso
```

## Repository-based configuration

I recently found a third solution, to specify the key to use for a specific repository, by [Richard Smith](https://stackoverflow.com/a/41947805).

This solution sets the `core.sshCommand` property:

```
git config --local core.sshCommand "/usr/bin/ssh -i /home/me/.ssh/id_rsa_foo"
```

You can't use this command when cloning a remote repository (since you don't have a local repository). The solution was proposed by [drewbie18](https://stackoverflow.com/a/56084858) :

```
git clone -c core.sshCommand="/usr/bin/ssh -i /home/me/.ssh/id_rsa_foo" git@github.com:me/repo.git
```

## Conclusion

I personally find the path-based solution much easier to use, since you only need to change your configuration once, and it automatically works in the future (as long as you use the correct folders for your projects). The host-based solution requires you to always be careful to change the URL when cloning a repository. But it can be useful if you don't want to group your projects in specific local directories.

