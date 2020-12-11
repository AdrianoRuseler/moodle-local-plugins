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


## Remove
```bash
git submodule deinit <path_to_submodule>
git rm <path_to_submodule>
git commit -m "Removed submodule "
rm -rf .git/modules/<path_to_submodule>
```
