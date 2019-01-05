# Master Chef API 👨‍🍳
Master Chef API - All API related to maker's kitchen functionality

## Maker Locations Slack Commands

Allowing makers in the kitchen to pin their current location and allow other makers to find them by searching makers in a specific location.

### Pin yourself in a city: `pin_me_in Paris`

[![NSolid](https://pbs.twimg.com/media/DwFLgpbV4AAz_wE.jpg:large)](https://twitter.com/its_dinuka/status/1081228423916208130)

### Find makers in a city: `find_makers_in Kuala Lumpur` 🗺

[![NSolid](https://pbs.twimg.com/media/DwFoD2ZU0AAiCj5.jpg:large)](https://twitter.com/its_dinuka/status/1081260106195427328)

## Maker Map API

If you wish to make use of the maker map API, there are two available endpoints.

### `list_all` - Get a complete map of all makers

**GET**
Base URL: `https://kitchen-master-chef.herokuapp.com/api/v1/maps/list_all`
Params - None


### `find` - Search for makers by location parameter

**GET**
Base URL: `https://kitchen-master-chef.herokuapp.com/api/v1/maps/find`
Params - `location` (Austin, Melbourne, etc)

Please do not build custom products that are outside of the Kitchen without the consent of the community. The locations pinned within the kitchen were consented to be used within the kitchen.
