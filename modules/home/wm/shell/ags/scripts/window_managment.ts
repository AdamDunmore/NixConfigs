import { Accessor, Setter } from "ags";

export const toggle_app = function(isWindowVisible: Accessor<boolean>, setIsWindowVisible: Setter<boolean>, setIsVisible: Setter<boolean>, transition_length = 400) {
    const v_status = isWindowVisible();
    if (!v_status) {
        setIsWindowVisible(!v_status);        
        setTimeout(() => { setIsVisible(!v_status) }, 1)
    } else{
        setIsVisible(!v_status);
        setTimeout(() => { setIsWindowVisible(!v_status) }, transition_length / 2)
    } 
};
