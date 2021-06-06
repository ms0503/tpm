/*
 *  tpm - the package manager for Linux.
 *  Copyright (C) 2021 Sora Tonami
 *
 *  This file is part of tpm.
 *
 *  tpm is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  tpm is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with tpm.  If not, see <https://www.gnu.org/licenses/>.
 */

'use strict';

const fs = require('fs');

class Msg {
    static data: any;

    static getMessage(id: string): string {
        if(Msg.data.msgs[id] === undefined) {
            console.error('Error: No such localized message');
            process.exit(4);
        }
        return Msg.data.msgs[id];
    }

    static init(lang: string): void {
        let currDir = __dirname;
        if(!fs.existsSync(`${currDir}/../lang/${lang}.lang`)) {
            console.error('Error: No such lang file');
            process.exit(2);
        }
        let langFile = fs.readFileSync(`${currDir}/../lang/${lang}.lang`);
        Msg.data = JSON.parse(langFile);
        if(!('msgs' in Msg.data)) {
            console.error('Error: Invalid lang file');
            process.exit(3);
        }
    }
}
