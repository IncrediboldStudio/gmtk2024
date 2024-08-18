extends Block

class_name Entry

var held_component: Component

func receive(component: Component):
    held_component = component
    component.visible = false
