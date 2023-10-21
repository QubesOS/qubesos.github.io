The following command-line instructions assume a Linux system with `git` and `gpg` installed. (For Windows and Mac options, see [OpenPGP software](/security/verifying-signatures/#openpgp-software).)

1. Obtain the Qubes Master Signing Key (QMSK), e.g.:

   ```shell_session
   $ gpg --fetch-keys https://keys.qubes-os.org/keys/qubes-master-signing-key.asc
   gpg: directory '/home/user/.gnupg' created
   gpg: keybox '/home/user/.gnupg/pubring.kbx' created
   gpg: requesting key from 'https://keys.qubes-os.org/keys/qubes-master-signing-key.asc'
   gpg: /home/user/.gnupg/trustdb.gpg: trustdb created
   gpg: key DDFA1A3E36879494: public key "Qubes Master Signing Key" imported
   gpg: Total number processed: 1
   gpg:               imported: 1
   ```

   (For more ways to obtain the QMSK, see [How to import and authenticate the Qubes Master Signing Key](/security/verifying-signatures/#how-to-import-and-authenticate-the-qubes-master-signing-key).)

2. View the fingerprint of the PGP key you just imported. (Note: `gpg>` indicates a prompt inside of the GnuPG program. Type what appears after it when prompted.)

   ```shell_session
   $ gpg --edit-key 0x427F11FD0FAA4B080123F01CDDFA1A3E36879494
   gpg (GnuPG) 2.2.27; Copyright (C) 2021 Free Software Foundation, Inc.
   This is free software: you are free to change and redistribute it.
   There is NO WARRANTY, to the extent permitted by law.
   
   
   pub  rsa4096/DDFA1A3E36879494
        created: 2010-04-01  expires: never       usage: SC
        trust: unknown       validity: unknown
   [ unknown] (1). Qubes Master Signing Key
   
   gpg> fpr
   pub   rsa4096/DDFA1A3E36879494 2010-04-01 Qubes Master Signing Key
    Primary key fingerprint: 427F 11FD 0FAA 4B08 0123  F01C DDFA 1A3E 3687 9494
   ```

3. **Important:** At this point, you still don't know whether the key you just imported is the genuine QMSK or a forgery. In order for this entire procedure to provide meaningful security benefits, you *must* authenticate the QMSK out-of-band. **Do not skip this step!** The standard method is to obtain the QMSK fingerprint from *multiple independent sources in several different ways* and check to see whether they match the key you just imported. For more information, see [How to import and authenticate the Qubes Master Signing Key](/security/verifying-signatures/#how-to-import-and-authenticate-the-qubes-master-signing-key).

   **Tip:** After you have authenticated the QMSK out-of-band to your satisfaction, record the QMSK fingerprint in a safe place (or several) so that you don't have to repeat this step in the future.

4. Once you are satisfied that you have the genuine QMSK, set its trust level to 5 ("ultimate"), then quit GnuPG with `q`.

   ```shell_session
   gpg> trust
   pub  rsa4096/DDFA1A3E36879494
        created: 2010-04-01  expires: never       usage: SC
        trust: unknown       validity: unknown
   [ unknown] (1). Qubes Master Signing Key
   
   Please decide how far you trust this user to correctly verify other users' keys
   (by looking at passports, checking fingerprints from different sources, etc.)
   
     1 = I don't know or won't say
     2 = I do NOT trust
     3 = I trust marginally
     4 = I trust fully
     5 = I trust ultimately
     m = back to the main menu
   
   Your decision? 5
   Do you really want to set this key to ultimate trust? (y/N) y
   
   pub  rsa4096/DDFA1A3E36879494
        created: 2010-04-01  expires: never       usage: SC
        trust: ultimate      validity: unknown
   [ unknown] (1). Qubes Master Signing Key
   Please note that the shown key validity is not necessarily correct
   unless you restart the program.
   
   gpg> q
   ```

5. Use Git to clone the qubes-secpack repo.

   ```shell_session
   $ git clone https://github.com/QubesOS/qubes-secpack.git
   Cloning into 'qubes-secpack'...
   remote: Enumerating objects: 4065, done.
   remote: Counting objects: 100% (1474/1474), done.
   remote: Compressing objects: 100% (742/742), done.
   remote: Total 4065 (delta 743), reused 1413 (delta 731), pack-reused 2591
   Receiving objects: 100% (4065/4065), 1.64 MiB | 2.53 MiB/s, done.
   Resolving deltas: 100% (1910/1910), done.
   ```

6. Import the included PGP keys. (See our [PGP key policies](/security/pack/#pgp-key-policies) for important information about these keys.)

   ```shell_session
   $ gpg --import qubes-secpack/keys/*/*
   gpg: key 063938BA42CFA724: public key "Marek Marczykowski-Górecki (Qubes OS signing key)" imported
   gpg: qubes-secpack/keys/core-devs/retired: read error: Is a directory
   gpg: no valid OpenPGP data found.
   gpg: key 8C05216CE09C093C: 1 signature not checked due to a missing key
   gpg: key 8C05216CE09C093C: public key "HW42 (Qubes Signing Key)" imported
   gpg: key DA0434BC706E1FCF: public key "Simon Gaiser (Qubes OS signing key)" imported
   gpg: key 8CE137352A019A17: 2 signatures not checked due to missing keys
   gpg: key 8CE137352A019A17: public key "Andrew David Wong (Qubes Documentation Signing Key)" imported
   gpg: key AAA743B42FBC07A9: public key "Brennan Novak (Qubes Website & Documentation Signing)" imported
   gpg: key B6A0BB95CA74A5C3: public key "Joanna Rutkowska (Qubes Documentation Signing Key)" imported
   gpg: key F32894BE9684938A: public key "Marek Marczykowski-Górecki (Qubes Documentation Signing Key)" imported
   gpg: key 6E7A27B909DAFB92: public key "Hakisho Nukama (Qubes Documentation Signing Key)" imported
   gpg: key 485C7504F27D0A72: 1 signature not checked due to a missing key
   gpg: key 485C7504F27D0A72: public key "Sven Semmler (Qubes Documentation Signing Key)" imported
   gpg: key BB52274595B71262: public key "unman (Qubes Documentation Signing Key)" imported
   gpg: key DC2F3678D272F2A8: 1 signature not checked due to a missing key
   gpg: key DC2F3678D272F2A8: public key "Wojtek Porczyk (Qubes OS documentation signing key)" imported
   gpg: key FD64F4F9E9720C4D: 1 signature not checked due to a missing key
   gpg: key FD64F4F9E9720C4D: public key "Zrubi (Qubes Documentation Signing Key)" imported
   gpg: key DDFA1A3E36879494: "Qubes Master Signing Key" not changed
   gpg: key 1848792F9E2795E9: public key "Qubes OS Release 4 Signing Key" imported
   gpg: qubes-secpack/keys/release-keys/retired: read error: Is a directory
   gpg: no valid OpenPGP data found.
   gpg: key D655A4F21830E06A: public key "Marek Marczykowski-Górecki (Qubes security pack)" imported
   gpg: key ACC2602F3F48CB21: public key "Qubes OS Security Team" imported
   gpg: qubes-secpack/keys/security-team/retired: read error: Is a directory
   gpg: no valid OpenPGP data found.
   gpg: key 4AC18DE1112E1490: public key "Simon Gaiser (Qubes Security Pack signing key)" imported
   gpg: Total number processed: 17
   gpg:               imported: 16
   gpg:              unchanged: 1
   gpg: marginals needed: 3  completes needed: 1  trust model: pgp
   gpg: depth: 0  valid:   1  signed:   6  trust: 0-, 0q, 0n, 0m, 0f, 1u
   gpg: depth: 1  valid:   6  signed:   0  trust: 6-, 0q, 0n, 0m, 0f, 0u
   ```

7. Verify signed Git tags.

   ```shell_session
   $ cd qubes-secpack/
   $ git tag -v `git describe`
   object 266e14a6fae57c9a91362c9ac784d3a891f4d351
   type commit
   tag marmarek_sec_266e14a6
   tagger Marek Marczykowski-Górecki 1677757924 +0100
   
   Tag for commit 266e14a6fae57c9a91362c9ac784d3a891f4d351
   gpg: Signature made Thu 02 Mar 2023 03:52:04 AM PST
   gpg:                using RSA key 2D1771FE4D767EDC76B089FAD655A4F21830E06A
   gpg: Good signature from "Marek Marczykowski-Górecki (Qubes security pack)" [full]
   ```

   The exact output will differ, but the final line should always start with `gpg: Good signature from...` followed by an appropriate key. The `[full]` indicates full trust, which this key inherits in virtue of being validly signed by the QMSK.

8. Verify PGP signatures, e.g.:

   ```shell_session
   $ cd QSBs/
   $ gpg --verify qsb-087-2022.txt.sig.marmarek qsb-087-2022.txt
   gpg: Signature made Wed 23 Nov 2022 04:05:51 AM PST
   gpg:                using RSA key 2D1771FE4D767EDC76B089FAD655A4F21830E06A
   gpg: Good signature from "Marek Marczykowski-Górecki (Qubes security pack)" [full]
   $ gpg --verify qsb-087-2022.txt.sig.simon qsb-087-2022.txt
   gpg: Signature made Wed 23 Nov 2022 03:50:42 AM PST
   gpg:                using RSA key EA18E7F040C41DDAEFE9AA0F4AC18DE1112E1490
   gpg: Good signature from "Simon Gaiser (Qubes Security Pack signing key)" [full]
   $ cd ../canaries/
   $ gpg --verify canary-034-2023.txt.sig.marmarek canary-034-2023.txt
   gpg: Signature made Thu 02 Mar 2023 03:51:48 AM PST
   gpg:                using RSA key 2D1771FE4D767EDC76B089FAD655A4F21830E06A
   gpg: Good signature from "Marek Marczykowski-Górecki (Qubes security pack)" [full]
   $ gpg --verify canary-034-2023.txt.sig.simon canary-034-2023.txt
   gpg: Signature made Thu 02 Mar 2023 01:47:52 AM PST
   gpg:                using RSA key EA18E7F040C41DDAEFE9AA0F4AC18DE1112E1490
   gpg: Good signature from "Simon Gaiser (Qubes Security Pack signing key)" [full]
   ```

   Again, the exact output will differ, but the final line of output from each `gpg --verify` command should always start with `gpg: Good signature from...` followed by an appropriate key.
