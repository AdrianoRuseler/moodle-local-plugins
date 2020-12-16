# moodle-local-plugins


## Plugins List

```bash
mkdir moodle
cd moodle
```


- https://moodle.org/plugins/local_adminer
- https://github.com/grabs/moodle-local_adminer

```bash
git submodule add -b MOODLE_39_STABLE https://github.com/grabs/moodle-local_adminer.git local/adminer
```

- https://moodle.org/plugins/local_staticpage
- https://github.com/moodleuulm/moodle-local_staticpage

```bash
git submodule add -b master https://github.com/moodleuulm/moodle-local_staticpage.git local/staticpage
```


- https://moodle.org/plugins/local_sandbox
- https://github.com/moodleuulm/moodle-local_sandbox
```bash
git submodule add -b master https://github.com/moodleuulm/moodle-local_sandbox.git local/sandbox
```


## Remove
```bash
git submodule deinit <path_to_submodule>
git rm <path_to_submodule>
git commit -m "Removed submodule "
rm -rf .git/modules/<path_to_submodule>
```

- https://moodle.org/plugins/local_mail
- https://gitlab.com/reskity/moodle-local_mail

```bash
git submodule add -b master https://gitlab.com/reskity/moodle-local_mail.git local/mail
```
