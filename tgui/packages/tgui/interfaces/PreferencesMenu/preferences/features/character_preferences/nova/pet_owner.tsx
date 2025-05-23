// THIS IS A NOVA SECTOR UI FILE
import {
  Feature,
  FeatureChoiced,
  FeatureShortTextInput,
  FeatureTextInput,
} from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const pet_owner: FeatureChoiced = {
  name: 'Pet Type',
  component: FeatureDropdownInput,
};

export const pet_gender: FeatureChoiced = {
  name: 'Pet Gender',
  component: FeatureDropdownInput,
};

export const pet_name: Feature<string> = {
  name: 'Pet Name',
  description:
    "If blank, will use the mob's default name. For example, 'axolotl' or 'chinchilla'.",
  component: FeatureShortTextInput,
};

export const pet_desc: Feature<string> = {
  name: 'Pet Description',
  description: "If blank, will use the mob's default description.",
  component: FeatureTextInput,
};
