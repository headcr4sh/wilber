namespace Wilber.Util {

public delegate void OptionalCallback<T> (T value);

public interface Optional<T> {
	public abstract bool has_value { get; protected set; }
	public abstract T value { get; protected set; }
	public abstract T value_or_default (T default_value);
	public abstract void if_has_value (OptionalCallback<T> fn, OptionalCallback<T>? fn_else = null);
	public abstract void if_no_value (OptionalCallback<T> fn1, OptionalCallback<T>? fn_else = null);
}

protected abstract class AbstractOptional<T> : Optional<T>, GLib.Object {

	private bool _has_value = false;
	private T _value;

	public override bool has_value {
		get { return this._has_value; }
		protected set { this._has_value = value; }
	}

	public override T value {
		get { return this._value; }
		protected set { this._value = value; }
	}

	public T value_or_default (T default_value) {
		return this.has_value ? this.value : default_value;
	}

	public void if_has_value (OptionalCallback<T> fn, OptionalCallback<T>? fn_else = null) {
		if (this.has_value) {
			fn (this.value);
		} else if (fn_else != null) {
			fn_else (this.value);
		}
	}
	public void if_no_value (OptionalCallback<T> fn, OptionalCallback<T>? fn_else = null) {
		if (!this.has_value) {
			fn (this.value);
		} else if (fn_else != null) {
			fn_else (this.value);
		}
	}

	public abstract string to_string ();
}

public class OptionalBool : AbstractOptional<bool> {
	public OptionalBool(bool? v) {
		this.set_value(v);
	}

	public void set_value (bool? value) {
		this.has_value = value != null;
		if (this.has_value) {
			this.value = value;
		}
	}

	public override string to_string () {
		if (this.has_value) {
			return @"$(this.value)";
		}
		return "<null>";
	}
}

public class OptionalInt8 : AbstractOptional<int8> {
	public OptionalInt8(int8? v) {
		this.set_value(v);
	}

	public void set_value (int8? value) {
		this.has_value = value != null;
		if (this.has_value) {
			this.value = value;
		}
	}

	public override string to_string () {
		if (this.has_value) {
			return @"$(this.value)";
		}
		return "<null>";
	}
}

public class OptionalInt16 : AbstractOptional<int16> {
	public OptionalInt16(int16? v) {
		this.set_value(v);
	}

	public void set_value (int16? value) {
		this.has_value = value != null;
		if (this.has_value) {
			this.value = value;
		}
	}

	public override string to_string () {
		if (this.has_value) {
			return @"$(this.value)";
		}
		return "<null>";
	}
}

public class OptionalInt32 : AbstractOptional<int32> {
	public OptionalInt32(int32? v) {
		this.set_value(v);
	}

	public void set_value (int32? value) {
		this.has_value = value != null;
		if (this.has_value) {
			this.value = value;
		}
	}

	public override string to_string () {
		if (this.has_value) {
			return @"$(this.value)";
		}
		return "<null>";
	}
}

public class OptionalInt64 : AbstractOptional<int64?> {
	public OptionalInt64(int64? v) {
		this.set_value(v);
	}

	public void set_value (int64? value) {
		this.has_value = value != null;
		if (this.has_value) {
			this.value = value;
		}
	}

	public override string to_string () {
		if (this.has_value) {
			return @"$(this.value)";
		}
		return "<null>";
	}
}

public class OptionalFloat : AbstractOptional<float?> {
	public OptionalFloat(float? v) {
		this.set_value(v);
	}

	public void set_value (float? value) {
		this.has_value = value != null;
		if (this.has_value) {
			this.value = value;
		}
	}

	public override string to_string () {
		if (this.has_value) {
			return @"$(this.value)";
		}
		return "<null>";
	}
}

public class OptionalDouble : AbstractOptional<double?> {
	public OptionalDouble(double? v) {
		this.set_value(v);
	}

	public void set_value (double? value) {
		this.has_value = value != null;
		if (this.has_value) {
			this.value = value;
		}
	}

	public override string to_string () {
		if (this.has_value) {
			return @"$(this.value)";
		}
		return "<null>";
	}
}

public class OptionalString : AbstractOptional<string> {
	public OptionalString(string? v) {
		this.set_value(v);
	}

	public void set_value (string? value) {
		this.has_value = value != null;
		if (this.has_value) {
			this.value = value;
		}
	}

	public override string to_string () {
		if (this.has_value) {
			return this.value;
		}
		return "<null>";
	}
}

}
