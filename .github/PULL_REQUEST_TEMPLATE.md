# Pull Request

## Summary

<!-- What changed and why? Keep it short. -->

## Scope

<!-- Check all that apply -->

- [ ] Role task(s) (`roles/*/tasks`)
- [ ] Role defaults/variables (`roles/*/defaults`, `group_vars`)
- [ ] Workflow/automation (`.github/workflows`)
- [ ] Documentation (`README.md`, `docs/*`, `CHANGELOG.md`)
- [ ] Security/scanning configuration
- [ ] Breaking change

## Related Issue

<!-- Example: Fixes #123 -->

## Validation

<!-- Share what you actually ran. Remove lines that do not apply. -->

```bash
./validate.sh
ansible-playbook main.yml --check
./test-role.sh <role-name>
```

```text
PLAY RECAP: ok=?, changed=?, failed=0
```

## Release Impact

<!-- Required when behavior, roles, or workflows change. -->

- [ ] Commit message follows Conventional Commits
- [ ] `CHANGELOG.md` updated (when needed)
- [ ] No release impact

## Checklist

- [ ] Changes are idempotent and follow Ansible best practices
- [ ] Tasks have appropriate tags
- [ ] Documentation is updated where relevant
- [ ] I reviewed my own diff

## Breaking Change / Migration

<!-- If not applicable, write "None". -->

## Reviewer Notes

<!-- Special instructions or areas for reviewers to focus on -->

---

**By submitting this pull request, I confirm that:**

* [ ] I have read and agree to the [Code of Conduct](../CODE_OF_CONDUCT.md)
* [ ] I have read the [Contributing Guidelines](../CONTRIBUTING.md)
* [ ] My contribution is licensed under the project's [MIT License](../LICENSE)
