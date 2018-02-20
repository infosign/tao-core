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
 * Copyright (c) 2008-2010 (original work) Deutsche Institut für Internationale Pädagogische Forschung (under the project TAO-TRANSFER);
 *               2009-2012 (update and modification) Public Research Centre Henri Tudor (under the project TAO-SUSTAIN & TAO-DEV);
 *
 */

use oat\tao\helpers\Layout;
use tao_helpers_form_FormFactory as FormFactory;

/**
 * This container initialize the login form.
 *
 * @access public
 * @author Bertrand Chevrier, <bertrand.chevrier@tudor.lu>
 * @package tao

 */
class tao_actions_form_Login extends tao_helpers_form_FormContainer
{
    /**
     * Short description of method initForm
     *
     * @access public
     * @author Bertrand Chevrier, <bertrand.chevrier@tudor.lu>
     * @return mixed
     */
    public function initForm()
    {
        $this->form = tao_helpers_form_FormFactory::getForm('loginForm');

        $connectElt = tao_helpers_form_FormFactory::getElement('connect', 'Submit');
        $connectElt->setValue(__('Log in'));
        $connectElt->setAttributes(array('disabled' => 'disabled'));
        $connectElt->addClass('disabled');
        $this->form->setActions(array($connectElt), 'bottom');
    }

    /**
     * Short description of method initElements
     *
     * @access public
     * @author Bertrand Chevrier, <bertrand.chevrier@tudor.lu>
     * @return mixed
     */
    public function initElements()
    {
        if (isset($this->data['redirect']) && !empty($this->data['redirect'])) {
            $hiddenElt = FormFactory::getElement('redirect', 'Hidden');
            $hiddenElt->setValue($this->data['redirect']);
            $this->form->addElement($hiddenElt);
        }

        $loginElt = FormFactory::getElement('login', 'Textbox');
        $loginElt->setDescription(__("Login"));
        $loginElt->setAttributes(array('autofocus' => 'autofocus'));
        $loginElt->addValidator(FormFactory::getValidator('NotEmpty'));
        $this->form->addElement($loginElt);

        $passwordWidgetId = (isset($this->data['enablePasswordReveal']) && !empty($this->data['enablePasswordReveal']))
            ? 'ViewableHiddenbox'
            : 'Hiddenbox';
        $passElt = FormFactory::getElement('password', $passwordWidgetId);
        $passElt->setDescription(__('Password'));
        $passElt->addValidator(FormFactory::getValidator('NotEmpty'));
        $this->form->addElement($passElt);

        if (isset($this->data['disable_auto_complete']) && !empty($this->data['disable_auto_complete'])) {
            $loginElt->setAttributes(array('autocomplete' => 'off'));
            $passElt->setAttributes(array('autocomplete' => 'off'));
        }
    }

}
