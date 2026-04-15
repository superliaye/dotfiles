---
description: Graduate old killswitches by alias and package
argument-hint: <alias> [optional: package selector e.g. tag:spartan-apps, or specific package]
---

Graduate killswitches for the given user alias (by default if not provided: liaye). If a package/tag is specified, scope to that; otherwise research all packages.

## Step 1: Find killswitches

Search for the alias across all `**/KillSwitch*.ts` and `**/killswitch*.ts` files in the repo using Grep. Extract each match's:
- Date (from the comment, e.g. `'MM/DD/YYYY'` or `'YYYY-MM-DD'`)
- Function name
- GUID
- File path (to determine the package)
- Description

If not specified, filter to killswitches older than 1 month from today's date. List them grouped by package name with dates, function names, and descriptions. Ask the user to confirm which ones to graduate before proceeding.

## Step 2: Graduate with rush ks-killer

Run `rush ks-killer` using `--id` with comma-separated GUIDs. Do NOT use `-p` to scope to a single project — let ks-killer find all cross-project references automatically.

```
rush ks-killer --id <guid1>,<guid2>,... --before-date <MM/DD/YYYY>
```

Or if the user confirmed specific GUIDs:
```
rush ks-killer --id <guid1>,<guid2>,...
```

## Step 3: Review and fix ks-killer output

ks-killer does mechanical code removal but often leaves behind dead code. Systematically check every changed file for:

1. **Dead interface fields**: Props/options marked `@deprecated` referencing the graduated KS that are no longer read. Remove the fields from the interface and all callers passing them.
2. **Unused state**: `useState` calls whose setter was only called inside removed KS guards. Remove the state entirely.
3. **Unused variables**: Variables destructured from context/props that were only used inside removed KS guards. Remove from destructuring.
4. **Stale dependency arrays**: `useCallback`/`useEffect` deps referencing removed variables. Remove the stale entries.
5. **Always-undefined values**: Props or params hardcoded to `undefined` after KS removal (e.g. `dataSources: undefined`). If the consumer ignores them, remove from both sides.
6. **Unused imports**: Imports that became unreferenced after removing KS code. Remove them.
7. **Unused SCSS classes**: CSS classes only referenced from removed KS code paths. Remove the class definitions.
8. **Stale comments**: `@deprecated - Remove when graduating <KS name>` comments for KSes that are now graduated. Remove them.
9. **Type errors**: ks-killer may inline a value like `regenerateInput.userPrompt` where the old code had `userPrompt || ''`. If the type is `string | undefined` but the target expects `string`, add `|| ''` or equivalent.
10. **Naming convention violations**: ks-killer prefixes unused params with `_` (e.g. `_mode`), but this repo's lint rule (`@typescript-eslint/naming-convention`) requires camelCase. Revert to the original param name without underscore — the original code compiled fine with unused callback params.

## Step 4: Check for cross-project killswitches

Search the entire repo for each graduated GUID to find copies in other packages:
```
grep -r "<guid>" --include="*.ts" --include="*.tsx" <repo-root>
```

If any cross-project copies exist outside the already-processed files, graduate those too by running ks-killer with `--id` (no `-p` flag), then repeat Step 3 for the new changes.

## Step 5: Build

Run `rush build -t <package-name>` for each affected package. Fix any errors or warnings, then rebuild until clean (0 errors, 0 warnings).

## Step 6: Report

Print the Merlin verification commands that ks-killer output:
```
Test-GridKillSwitch -KillSwitchId "<guid>" -Global
```

Remind the user to run these in Merlin before merging to confirm none are currently activated in production.

$ARGUMENTS
