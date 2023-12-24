package src

type Option[T any] struct {
	exist bool
	value T
}

func option_some[T any](value T) Option[T] {
	return Option[T]{
		exist: true,
		value: value,
	}
}

func option_none[T any]() Option[T] {
	return Option[T]{
		exist: false,
	}
}

func (self *Option[T]) is_some() bool {
	return self.exist
}

func (self *Option[T]) is_none() bool {
	return !self.exist
}

func (self Option[T]) unwrap() T {
	if !self.exist {
		panic("unwrapping None value")
	}
	return self.value
}
