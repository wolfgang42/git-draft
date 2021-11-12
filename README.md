# git-draft
`git-draft` is a new way to manage changes to your `git` worktree before committing.
It replaces the git index/staging area with the concept of “draft commits”. Its philosophy is best summarized with the phrase:

**Stash, don't stage!**

To `git-draft`, the index is irrelevant; the working directory is the only source of truth.
Instead of staging the changes you want, stash the changes you *don't* want, then commit what remains.
Think of it as a workflow built on top of `git add -A` with extra features,
or a less-confusing version of `git stash`.

The advantage of this approach is that it makes sure the commit will always match the workdir.
This way things like tests and pre-commit hooks always see the actual contents of the commit without other unstaged changes mixed in.

The *disadvantage* is that you can't keep things lying around your working directory without committing them.
The hope is that `git-draft` makes it easy enough to stash changes that this isn't a problem.
For some purposes, the `.git/info/exclude` file may also be helpful.

## Status
🧪 `git-draft` is currently an experimental prototype.

I’m publishing it to get feedback on the design, and attract interest in improving this aspect of the Git user experience.
The data model (see Implementation below) seems pretty good,
but the current implementation needs to be completely rewritten to become production-ready.
(See the Bugs section at the bottom of this doc for a brief overview of the situation.)

Please try it out and open issues and discussions. Even if it’s just “I don’t understand this at all” that’s still useful feedback to get!

Caveats:
* There are a *lot* of edge cases for which `git-draft` will fail with mysterious error messages;
  bug reports gladly accepted. I’ve been trying to catch these as I find them,
  but the current implementation is not exactly robust.
* I can't guarantee it won't eat your data. (I trust it enough to use it on our monorepo at work, and I’ve never had it mangle anything, but caveat emptor nonetheless.)
* Breaking changes will be announced in the release notes, but may come at any time.

I don’t recommend it for beginner git users, yet.
Everybody is already using the staging area so if you run into trouble you can usually find advice to help.
The same is not true of `git-draft`, so even though the ‘draft commit’ model is conceptually simpler,
nobody will know how to fix it if you get into a muddle.

## Installation
`git-draft` is distributed as a single large Bash script. After installation, `git` will automatically detect it and make `git draft` commands work. To install:

* Download the latest version from the releases page.
* Put it somewhere in your `$PATH`, like `/usr/local/bin`.
* Mark the file as executable with `chmod a+x /path/to/git-draft`.
* Test that it’s working by running `git draft help`.

(To un-install, remove this file. `git-draft` does not create any other files or settings.)

**Note for MacOS users:** `git-draft` requires Bash 4.2 or greater. MacOS ships with the horribly out of date Bash 3.2 (from 2006!), so you will need to get a newer version of Bash first. If you use homebrew, you can upgrade with:
```sh
brew install bash
```

## Quick start
`git-draft` doesn’t need any setup; you can start using it on a repository at any time. (You can also *stop* using it at any time. The output of `git draft status` may be slightly confusing if you ran `git commit` while you had a named draft active, but nothing will break.)

If you start with a clear working directory, `git draft status` will tell you that you have an “empty draft on *branch*”.

Make some changes and run `git draft status` again. You will see the changed files. Notice that staged and unstaged files are displayed the same way, because `git-draft` does not care about this distinction.

Run `git draft message` and write a message explaining the changes you made. (The editor will have a `Draft-on` trailer at the bottom. This is a bit of plumbing sticking out and can be ignored.) Run `git draft status` again and notice that it now has the message you just wrote.

When you are ready to commit the changes you’ve drafted, run `git draft commit`. (You can also run `git draft commit --no-edit` if you don’t need to change the commit message again.) You will now have a new commit, and `git draft status` will once again report that your active draft is empty.

Make some changes again, but this time instead of committing them run `git draft switch -c`. This will stash your active draft (printing the name assigned to the draft), and give you an empty draft again. (The `-c` stands for `--create`, because you are creating a new empty draft rather than switching to an existing draft.) Run `git draft list` to see your newly created draft.

To switch back to the draft you just stashed, run `git draft switch <draft-name>`. If you have a non-empty draft active already, it will be automatically stashed to make way for the draft you are switching to. If the draft was created on a different branch, that branch will be automatically checked out as well. (See the `--onto` options to `git draft switch` for ways to change this.)

This should be all you need to get started using `git draft` in your workflow. For more advanced options, see Commands and Concepts below.

## Commands
Use `git draft help` and `git draft <subcommand> --help` to view flags and more options. The major subcommands are:

* `git draft status`: Draft-aware replacement for `git status` (mostly—for implementation reasons it's currently missing some info from `git status`)
* `git draft commit`: Draft-aware replacement for `git commit`: make the active draft into an actual commit. (Understands draft messages and doesn't require staging changes first.)

* `git draft message`: Edit the active draft's message. Useful to prepare a commit message before committing.

* `git draft list`: View a list of all drafts.

* `git draft switch -c`: Stash the active draft and start a new empty draft
* `git draft switch <draft-name>`: Stash the active draft (if any) and switch to a stashed draft. By default, also switches to the branch that the draft was created on.
* `git draft create`: Create a new (possibly named) stashed draft.
* `git draft create -id`: Put staged changes into a new stashed draft, and remove them from the working directory. Useful to split up changes into separate drafts and commits.
* `git draft show`: Display a draft (like `git show`).
* `git draft drop`: Delete a draft.

(These are the porcelain commands. Plumbing commands are documented throughout the Implementation section below.)

## Concepts
`git-draft` introduces the concept of *draft commits* (usually just called "drafts" for brevity and clarity).
A draft has a parent commit, a commit message, and a tree.
Drafts do not have committer/author dates or a hash.
Notably, a draft's message can be edited at any time, so you can start writing a commit message before you make the commit.

A draft can be in one of two states:
* The *active draft* is the draft currently being worked on; its tree is the working directory. There is always an active draft,
  though it may be an *empty draft* if (a) the draft has not been given a name, (b) the working directory is clean, and
  (c) the draft has no message.
* *Stashed drafts* are drafts other than the active draft, which have been put away for later. They are stored inside `.git` and can be activated with `git draft switch`.

*Draft names* have the same requirements as branch names.
All stashed drafts have unique names.
It is not possible for a single draft to have multiple names.
The active draft may, but is not required to, have a draft name.
If a draft name is needed but not provided (for example, when an unnamed active draft is stashed or when `git draft create` is called),
a draft name is autogenerated from the name of HEAD plus a random identifier.
The draft name `active` is reserved as a reference to the active draft (and is the only exception to the "multiple names for one draft" rule).

An *empty draft* is what you get when the active draft has no name, message, or changed files.
(Empty drafts only appear as active drafts, since all staged drafts have a name.)
If the active draft is an empty draft and you switch to another draft, the empty draft simply disappears.

A *blank draft* is a draft which has a name, but no message or changed files.
A blank draft may be created by explicitly naming an empty draft, or by `git draft create`.

A *bare draft* is a draft which has a message, but no changed files.
A bare draft may be created by adding a message to a blank or empty draft.

When switching to a different draft:
* The current active draft is stashed (if not empty) and the working directory cleaned.
* The selected draft is set as the active draft.
* The selected draft's changes are applied to the working directory.

## Implementation
The active draft is actually an implicit entity, with no reified representation:
* its tree is the working directory
* its parent is HEAD
* its commit message is stored in `.git/GITDASH_DRAFT_COMMIT_EDITMSG`
* its name is stored as a [trailer](https://git-scm.com/docs/git-interpret-trailers) called `Draft-ref` on the message

An "empty active draft" is simply what you get when
* the working tree has no changes, and
* `.git/GITDASH_DRAFT_COMMIT_EDITMSG` does not exist or is zero bytes long

The plumbing commands `stash-active` and `activate-stashed` convert between the active and staged forms.
They check that the active draft is empty before making changes to ensure that a bug doesn't cause two drafts to collide.
The plumbing command `active-is-empty` implements the check for this state.

Stashed drafts are currently stored as commits under `refs/drafts/`.
Their tree/parent/message are stored in this commit, and when the draft is edited the ref is changed to a new commit accordingly.
(As a result, the note in the Concepts section that "drafts do not have committer/author dates or a hash" is not strictly accurate for stashed drafts,
but that should be considered an implementation detail and not relied on.)
The HEAD at the time they were stashed is also stored, as a trailer called `Draft-on`, and is used by default to check out the same
branch when switching back to the stashed draft. (This can be changed with the various `--onto` options to `git draft switch`.)

Despite the name, stashed drafts do not use `git stash`, since the structure that produces is somewhat unsuitable.
`git stash` entries have two commits, one for the index and one for the working tree, but the former is not needed for drafts;
also, it is not possible to give them stable names and they are instead stored as a "stack" in the reflog of `refs/stash`.

"Merge drafts" do not exist (yet?); a draft can only have one parent.
For the moment, the parent commit of a draft must be an actual commit, not a draft; if you want to stack them, a branch is a better idea.

## Bugs
* `git-draft` is completely oblivious to the index. This is by design, but it would be nice to have index-aware commands
  so that more conventional tools can be used at the same time. (For example, you could interactively add things to the
  index with `git gui` and then stash only those changes into a draft, leaving the unstaged changes in the active draft.)
  `git draft create --from-index` is a rudimentary version of this.
* Various information about drafts is stored as commit message trailers. This causes clutter when editing messages.
* It probably doesn't interact well with worktrees right now.
  (It certainly doesn't have a concept of multiple active drafts. I *think* that the current implementation should largely work,
  but I have not tried it yet.)
* A lot of basic operations (`get-commit-message` and `describe` in particular) are quite slow, so the whole thing tends to be
  kind of sluggish.
* Older versions of drafts ought to be retrievable via the reflog, but I haven't investigated exactly how to make this work.
* There's no way to rename a draft once it gets a name, mostly because I haven't needed this.
* In general, there are probably some interesting edge cases with how drafts interact with other parts of `git`.
* `git-draft` is currently implemented as a collection of Bash scripts. This works reasonably well
  and was an excellent way to get a prototype working, but there are some things
  that are simply not practical without making `git-draft` part of the `git` suite rather than a standalone program.
  For example, commit messages are missing all of the useful notes that Git adds in the editor.
  (The shell-based implementation also has performance problems, since a lot of forking needs to happen—particularly
  for `git-draft list` which is noticeably slowish even with only a few drafts.)
