- State: discussing

# Deployment Steps

Currently, deployment consists of these steps: `drain, stop, delete, create, pre-start, start, post-start, post-deploy`.
For certain commands, users can exclude the drain step, by using e.g. `bosh stop --skip-drain`
for other commands, this is not possible.

Instead of maintaining a list of `--skip-something` flags for all bosh commands, we propose exposing the steps of a deployment directly to the user. Commands dealing with a series of steps (e.g `bosh stop` deals with `drain, stop, delete` while `bosh start` deals with `create, pre-start, start, post-start`) can make use of this functionality.

By default, all steps are executed.

proposed interaction using whitelist
`bosh -e my-bosh deploy -d cf cf.yml --steps='stop, delete, create, pre-start, start, post-start'`
or shorter, using blacklist
`bosh -e my-bosh deploy -d cf cf.yml --skip-steps='drain'`
`bosh -e stop -d cf api/1235465-234-234444 --skip-steps='drain'`


depending on the use-case, either white- or blacklist is more convenient.

use-cases:
* skipping drain to repair/stop/delete without evacuating data. drain might not what you want in *this specifc case*
* 
* executing pre-start only on first deploy? some other mechanism might be better here, this is not something you'd want to leave up to humans.

issues/dangers:
* skipping certain steps might not lead to a desired result. Eg. skipping 'delete' or 'create' probably doesn't make much sense during a deploy. Many steps are not really optional without breaking functionality
* how do users discover/know about steps? How frequent are those changing?
  * if infrequent: hardcoded CLI switches might be enough instead of generic concept
  * if frequent: how would we frequently update those documentations/helps to match up with the new steps?
