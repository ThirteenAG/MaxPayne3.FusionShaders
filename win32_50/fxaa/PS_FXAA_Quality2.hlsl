cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
	float4 globalScalars2 : packoffset(c1);
	float4 globalScalars3 : packoffset(c2);
	float4 globalScalars4 : packoffset(c3);
	float4 globalFogParams : packoffset(c4);
	float4 globalFogColor : packoffset(c5);
	float4 globalFogOffsetN : packoffset(c6);
	float4 globalFogColorN : packoffset(c7);
	float4 globalScreenSize : packoffset(c8);
};

SamplerState BackBufferSampler : register(s0);
Texture2D BackBuffer : register(t0);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
	float2 texcoord2 : TEXCOORD2;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	int4 r1;
	int4 r2;
	int4 r3;
	int4 r4;
	int3 r5;
	r0 = BackBuffer.SampleLevel(BackBufferSampler, i.texcoord.xy, 0);
	r1.xyz = asint(BackBuffer.GatherAlpha(BackBufferSampler, i.texcoord.xy).xyz);
	r2.xyz = asint(BackBuffer.GatherAlpha(BackBufferSampler, i.texcoord.xy, int2(-1, -1)).xzw);
	r1.w = asint(max(r0.w, asfloat(r1.x)));
	r2.w = asint(min(r0.w, asfloat(r1.x)));
	r1.w = asint(max(asfloat(r1.w), asfloat(r1.z)));
	r2.w = asint(min(asfloat(r1.z), asfloat(r2.w)));
	r3.x = asint(max(asfloat(r2.x), asfloat(r2.y)));
	r3.y = asint(min(asfloat(r2.x), asfloat(r2.y)));
	r1.w = asint(max(asfloat(r1.w), asfloat(r3.x)));
	r2.w = asint(min(asfloat(r2.w), asfloat(r3.y)));
	r3.x = asint(asfloat(r1.w) * 0.165999994);
	r1.w = asint(asfloat(r1.w) + -(asfloat(r2.w)));
	r2.w = asint(max(asfloat(r3.x), 0.0833000019));
	r2.w = (asfloat(r1.w) >= asfloat(r2.w)) ? -1 : 0;
	if (r2.w != 0) {
		r2.w = asint(BackBuffer.SampleLevel(BackBufferSampler, i.texcoord.xy, 0, int2(1, -1)).w);
		r3.x = asint(BackBuffer.SampleLevel(BackBufferSampler, i.texcoord.xy, 0, int2(-1, 1)).w);
		r3.yz = asint(asfloat(r1.xz) + asfloat(r2.yx));
		r1.w = asint(1 / asfloat(r1.w));
		r3.w = asint(asfloat(r3.z) + asfloat(r3.y));
		r3.yz = asint(r0.ww * float2(-2, -2) + asfloat(r3.yz));
		r4.x = asint(asfloat(r1.y) + asfloat(r2.w));
		r2.w = asint(asfloat(r2.w) + asfloat(r2.z));
		r4.y = asint(asfloat(r1.z) * -2 + asfloat(r4.x));
		r2.w = asint(asfloat(r2.y) * -2 + asfloat(r2.w));
		r2.z = asint(asfloat(r2.z) + asfloat(r3.x));
		r1.y = asint(asfloat(r1.y) + asfloat(r3.x));
		r3.x = asint(abs(asfloat(r3.y)) * 2 + abs(asfloat(r4.y)));
		r2.w = asint(abs(asfloat(r3.z)) * 2 + abs(asfloat(r2.w)));
		r3.y = asint(asfloat(r2.x) * -2 + asfloat(r2.z));
		r1.y = asint(asfloat(r1.x) * -2 + asfloat(r1.y));
		r3.x = asint(asfloat(r3.x) + abs(asfloat(r3.y)));
		r1.y = asint(asfloat(r2.w) + abs(asfloat(r1.y)));
		r2.z = asint(asfloat(r4.x) + asfloat(r2.z));
		r1.y = (asfloat(r3.x) >= asfloat(r1.y)) ? -1 : 0;
		r2.z = asint(asfloat(r3.w) * 2 + asfloat(r2.z));
		r2.x = (r1.y != 0) ? r2.y : r2.x;
		r1.x = (r1.y != 0) ? r1.x : r1.z;
		r1.z = asint((r1.y != 0) ? globalScreenSize.w : globalScreenSize.z);
		r2.y = asint(asfloat(r2.z) * 0.0833333358 + -(r0.w));
		r2.z = asint(-(r0.w) + asfloat(r2.x));
		r2.w = asint(-(r0.w) + asfloat(r1.x));
		r2.x = asint(r0.w + asfloat(r2.x));
		r1.x = asint(r0.w + asfloat(r1.x));
		r3.x = (abs(asfloat(r2.z)) >= abs(asfloat(r2.w))) ? -1 : 0;
		r2.z = asint(max(abs(asfloat(r2.w)), abs(asfloat(r2.z))));
		r1.z = (r3.x != 0) ? asint(-(asfloat(r1.z))) : r1.z;
		r1.w = asint(saturate(asfloat(r1.w) * abs(asfloat(r2.y))));
		r2.y = r1.y & asint(globalScreenSize.z);
		r2.w = (r1.y != 0) ? 0 : asint(globalScreenSize.w);
		r3.yz = asint(asfloat(r1.zz) * float2(0.5, 0.5) + i.texcoord.xy);
		r3.y = (r1.y != 0) ? asint(i.texcoord.x) : r3.y;
		r3.z = (r1.y != 0) ? r3.z : asint(i.texcoord.y);
		r4.xy = asint(-(asfloat(r2.yw)) + asfloat(r3.yz));
		r5.xy = asint(asfloat(r2.yw) + asfloat(r3.yz));
		r3.y = asint(asfloat(r1.w) * -2 + 3);
		r3.z = asint(BackBuffer.SampleLevel(BackBufferSampler, asfloat(r4.xy), 0).w);
		r1.w = asint(asfloat(r1.w) * asfloat(r1.w));
		r3.w = asint(BackBuffer.SampleLevel(BackBufferSampler, asfloat(r5.xy), 0).w);
		r1.x = (r3.x != 0) ? r2.x : r1.x;
		r2.x = asint(asfloat(r2.z) * 0.25);
		r2.z = asint(-(asfloat(r1.x)) * 0.5 + r0.w);
		r1.w = asint(asfloat(r1.w) * asfloat(r3.y));
		r2.z = (asfloat(r2.z) < 0) ? -1 : 0;
		r3.x = asint(-(asfloat(r1.x)) * 0.5 + asfloat(r3.z));
		r3.y = asint(-(asfloat(r1.x)) * 0.5 + asfloat(r3.w));
		r3.zw = (abs(asfloat(r3.xy)) >= asfloat(r2.xx)) ? -1 : 0;
		r4.z = asint(-(asfloat(r2.y)) * 1.5 + asfloat(r4.x));
		r4.x = (r3.z != 0) ? r4.x : r4.z;
		r4.w = asint(-(asfloat(r2.w)) * 1.5 + asfloat(r4.y));
		r4.z = (r3.z != 0) ? r4.y : r4.w;
		r4.yw = ~r3.zw;
		r4.y = r4.w | r4.y;
		r4.w = asint(asfloat(r2.y) * 1.5 + asfloat(r5.x));
		r5.x = (r3.w != 0) ? r5.x : r4.w;
		r4.w = asint(asfloat(r2.w) * 1.5 + asfloat(r5.y));
		r5.z = (r3.w != 0) ? r5.y : r4.w;
		if (r4.y != 0) {
			if (r3.z == 0) {
				r3.x = asint(BackBuffer.SampleLevel(BackBufferSampler, asfloat(r4.xz), 0).w);
			}
			if (r3.w == 0) {
				r3.y = asint(BackBuffer.SampleLevel(BackBufferSampler, asfloat(r5.xz), 0).w);
			}
			r4.y = asint(-(asfloat(r1.x)) * 0.5 + asfloat(r3.x));
			r3.x = (r3.z != 0) ? r3.x : r4.y;
			r3.z = asint(-(asfloat(r1.x)) * 0.5 + asfloat(r3.y));
			r3.y = (r3.w != 0) ? r3.y : r3.z;
			r3.zw = (abs(asfloat(r3.xy)) >= asfloat(r2.xx)) ? -1 : 0;
			r4.y = asint(-(asfloat(r2.y)) * 2 + asfloat(r4.x));
			r4.x = (r3.z != 0) ? r4.x : r4.y;
			r4.y = asint(-(asfloat(r2.w)) * 2 + asfloat(r4.z));
			r4.z = (r3.z != 0) ? r4.z : r4.y;
			r4.yw = ~r3.zw;
			r4.y = r4.w | r4.y;
			r4.w = asint(asfloat(r2.y) * 2 + asfloat(r5.x));
			r5.x = (r3.w != 0) ? r5.x : r4.w;
			r4.w = asint(asfloat(r2.w) * 2 + asfloat(r5.z));
			r5.z = (r3.w != 0) ? r5.z : r4.w;
			if (r4.y != 0) {
				if (r3.z == 0) {
					r3.x = asint(BackBuffer.SampleLevel(BackBufferSampler, asfloat(r4.xz), 0).w);
				}
				if (r3.w == 0) {
					r3.y = asint(BackBuffer.SampleLevel(BackBufferSampler, asfloat(r5.xz), 0).w);
				}
				r4.y = asint(-(asfloat(r1.x)) * 0.5 + asfloat(r3.x));
				r3.x = (r3.z != 0) ? r3.x : r4.y;
				r3.z = asint(-(asfloat(r1.x)) * 0.5 + asfloat(r3.y));
				r3.y = (r3.w != 0) ? r3.y : r3.z;
				r3.zw = (abs(asfloat(r3.xy)) >= asfloat(r2.xx)) ? -1 : 0;
				r4.y = asint(-(asfloat(r2.y)) * 4 + asfloat(r4.x));
				r4.x = (r3.z != 0) ? r4.x : r4.y;
				r4.y = asint(-(asfloat(r2.w)) * 4 + asfloat(r4.z));
				r4.z = (r3.z != 0) ? r4.z : r4.y;
				r4.yw = ~r3.zw;
				r4.y = r4.w | r4.y;
				r4.w = asint(asfloat(r2.y) * 4 + asfloat(r5.x));
				r5.x = (r3.w != 0) ? r5.x : r4.w;
				r4.w = asint(asfloat(r2.w) * 4 + asfloat(r5.z));
				r5.z = (r3.w != 0) ? r5.z : r4.w;
				if (r4.y != 0) {
					if (r3.z == 0) {
						r3.x = asint(BackBuffer.SampleLevel(BackBufferSampler, asfloat(r4.xz), 0).w);
					}
					if (r3.w == 0) {
						r3.y = asint(BackBuffer.SampleLevel(BackBufferSampler, asfloat(r5.xz), 0).w);
					}
					r4.y = asint(-(asfloat(r1.x)) * 0.5 + asfloat(r3.x));
					r3.x = (r3.z != 0) ? r3.x : r4.y;
					r1.x = asint(-(asfloat(r1.x)) * 0.5 + asfloat(r3.y));
					r3.y = (r3.w != 0) ? r3.y : r1.x;
					r3.zw = (abs(asfloat(r3.xy)) >= asfloat(r2.xx)) ? -1 : 0;
					r1.x = asint(-(asfloat(r2.y)) * 12 + asfloat(r4.x));
					r4.x = (r3.z != 0) ? r4.x : r1.x;
					r1.x = asint(-(asfloat(r2.w)) * 12 + asfloat(r4.z));
					r4.z = (r3.z != 0) ? r4.z : r1.x;
					r1.x = asint(asfloat(r2.y) * 12 + asfloat(r5.x));
					r5.x = (r3.w != 0) ? r5.x : r1.x;
					r1.x = asint(asfloat(r2.w) * 12 + asfloat(r5.z));
					r5.z = (r3.w != 0) ? r5.z : r1.x;
				}
			}
		}
		r1.x = asint(-(asfloat(r4.x)) + i.texcoord.x);
		r2.y = asint(-(asfloat(r4.z)) + i.texcoord.y);
		r1.x = (r1.y != 0) ? r1.x : r2.y;
		r2.xy = asint(asfloat(r5.xz) + -(i.texcoord.xy));
		r2.x = (r1.y != 0) ? r2.x : r2.y;
		r2.yw = (asfloat(r3.xy) < float2(0, 0)) ? -1 : 0;
		r3.x = asint(asfloat(r1.x) + asfloat(r2.x));
		r2.yz = (r2.yw != r2.zz) ? -1 : 0;
		r2.w = asint(1 / asfloat(r3.x));
		r3.x = (asfloat(r1.x) < asfloat(r2.x)) ? -1 : 0;
		r1.x = asint(min(asfloat(r1.x), asfloat(r2.x)));
		r2.x = (r3.x != 0) ? r2.y : r2.z;
		r1.w = asint(asfloat(r1.w) * asfloat(r1.w));
		r1.x = asint(asfloat(r1.x) * -(asfloat(r2.w)) + 0.5);
		r1.w = asint(asfloat(r1.w) * 0.75);
		r1.x = r1.x & r2.x;
		r1.x = asint(max(asfloat(r1.w), asfloat(r1.x)));
		r1.xz = asint(asfloat(r1.xx) * asfloat(r1.zz) + i.texcoord.xy);
		r2.x = (r1.y != 0) ? asint(i.texcoord.x) : r1.x;
		r2.y = (r1.y != 0) ? r1.z : asint(i.texcoord.y);
		r0.xyz = BackBuffer.SampleLevel(BackBufferSampler, asfloat(r2.xy), 0).xyz;
	}
	o = saturate(r0);

	return o;
}
