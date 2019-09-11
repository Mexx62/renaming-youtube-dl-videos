# rename-youtube-dl-videos.sh

Script used to organize your video library downloaded with [youtube-dl](https://github.com/ytdl-org/youtube-dl/) and make it parseable by media centers.  
It parses the metadata file (`video_name.info.json`) to rename the video as `SxxEyy - video_name`:
- _xx_ the year index (01 for the year this first channel's video was uploaded)
- _yy_ the video index (01 for the first video uploaded this year on the channel)

Each season is thus composed of all the videos released per year.

## Prerequisites

- _jq_
- _bash_ v4.0 minimum

## Installation

- Clone the repo
- `chmod +x rename_videos.sh`
- Execute the script in your Videos folder

## Usage

When downloading videos with [youtube-dl](https://github.com/ytdl-org/youtube-dl/), the flag `write-info-json` is **necessary**.  
The script `rename_videos.sh` then has to be executed in the video library folder. It will check each subdirectories for `*.info.json` files. When it finds some, it will extract all uploading dates with _jq_ and rename the files given this information.

## Contributing

Do not hesitate to create an issue to spark discussion or submit a PR if you see an improvement that needs to be made!

## License
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
