<?php
/**
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; under version 2
 * of the License (non-upgradable).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 *
 * Copyright (c) 2015 (original work) Open Assessment Technologies SA (under the project TAO-PRODUCT);
 *
 */
namespace oat\tao\model\theme;

use oat\oatbox\service\ConfigurableService;
use oat\taoAct\model\theme\ActTheme;
use Aws\CloudFront\Exception\Exception;
/**
 * 
 * @author Joel Bout
 */
class ThemeService extends ConfigurableService {

    const SERVICE_ID = 'tao/theming';
    
    const OPTION_AVAILABLE = 'available';
    
    const OPTION_CURRENT = 'current';
    
    public function getTheme()
    {
        return $this->getThemeById($this->getOption(self::OPTION_CURRENT));
    }
    
    public function setTheme(Theme $theme)
    {
        $id = $this->addTheme($theme);
        $this->setOption(self::OPTION_CURRENT, $id);
    }
    
    
    public function addTheme(Theme $theme)
    {
        $themes = $this->getOption(self::OPTION_AVAILABLE);
        $baseId = method_exists($theme, 'getId') ? $theme->getId() : '';
        $nr = 0;
        while (isset($themes[$baseId.$nr])) {
            $nr++;
        }
        $themes[$baseId.$nr] = $theme;
        $this->setOption(self::OPTION_AVAILABLE, $themes);
        return $baseId.$nr;
    }
    
    protected function getThemeById($id)
    {
        $themes = $this->getOption(self::OPTION_AVAILABLE);
        if (isset($themes[$id])) {
            return $themes[$id];
        } else {
            throw new \common_exception_InconsistentData('Theme not found');
        }
    }
}