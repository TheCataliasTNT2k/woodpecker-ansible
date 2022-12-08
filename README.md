# woodpecker-ansible

This repository provides a open container standard base image for woodpecker ci jobs which require ansible.

Checkout the following projects to understand what this is all about:

- [`woodpecker-ansible-vyos-ci`](https://github.com/secshellnet/woodpecker-ansible-vyos-ci)
- [`woodpecker-ansible-vyos-cd`](https://github.com/secshellnet/woodpecker-ansible-vyos-cd)

Thank you [@TheCataliasTNT2k](https://github.com/thecataliastnt2k) for the python implementation to gather the hosts with configuration changes (optimized for our ansible-vyos, checkout our [example structure in the ansible-vyos-validator repo](https://github.com/secshellnet/ansible-vyos-validator/tree/main/example)).

## Information regarding [`ansible.patch`](./ansible.patch)
The [ansible vyos collection](https://docs.ansible.com/ansible/latest/collections/vyos/vyos/index.html) has some weird bugs. The sequence ESC+m appears randomly in the running_configuration, which ansible gathers on every job. The patch removes these sequences from the received data, to prevent ansible from running into errors.

You can generate such a patch using `diff -u original changed > ansible.patch`, I suggest adjusting the file paths (first two lines). Afterwards you may apply the patch using `patch filename < ansible.patch`.
