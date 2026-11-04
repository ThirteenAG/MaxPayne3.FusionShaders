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

	int4 r0;
	int4 r1;
	int4 r2;
	int4 r3;
	int4 r4;
	int4 r5;
	int4 r6;
	float4 r7;
	float4 r8;
	r0 = asint(BackBuffer.SampleLevel(BackBufferSampler, i.texcoord.xy, 0));
	r1 = asint(BackBuffer.SampleLevel(BackBufferSampler, i.texcoord.xy, 0, int2(0, 1)));
	r2 = asint(BackBuffer.SampleLevel(BackBufferSampler, i.texcoord.xy, 0, int2(1, 0)));
	r3 = asint(BackBuffer.SampleLevel(BackBufferSampler, i.texcoord.xy, 0, int2(0, -1)));
	r4 = asint(BackBuffer.SampleLevel(BackBufferSampler, i.texcoord.xy, 0, int2(-1, 0)));
	r1.x = asint(max(asfloat(r0.w), asfloat(r1.w)));
	r1.y = asint(min(asfloat(r0.w), asfloat(r1.w)));
	r1.x = asint(max(asfloat(r1.x), asfloat(r2.w)));
	r1.y = asint(min(asfloat(r1.y), asfloat(r2.w)));
	r1.z = asint(max(asfloat(r3.w), asfloat(r4.w)));
	r2.x = asint(min(asfloat(r3.w), asfloat(r4.w)));
	r1.x = asint(max(asfloat(r1.x), asfloat(r1.z)));
	r1.y = asint(min(asfloat(r1.y), asfloat(r2.x)));
	r1.z = asint(asfloat(r1.x) * 0.165999994);
	r1.x = asint(-(asfloat(r1.y)) + asfloat(r1.x));
	r1.y = asint(max(asfloat(r1.z), 0.0833000019));
	r1.y = (asfloat(r1.x) >= asfloat(r1.y)) ? -1 : 0;
	if (r1.y != 0) {
		r5 = asint(BackBuffer.SampleLevel(BackBufferSampler, i.texcoord.xy, 0, int2(-1, -1)));
		r6 = asint(BackBuffer.SampleLevel(BackBufferSampler, i.texcoord.xy, 0, int2(1, 1)));
		r7 = BackBuffer.SampleLevel(BackBufferSampler, i.texcoord.xy, 0, int2(1, -1));
		r8 = BackBuffer.SampleLevel(BackBufferSampler, i.texcoord.xy, 0, int2(-1, 1));
		r1.y = asint(asfloat(r1.w) + asfloat(r3.w));
		r1.z = asint(asfloat(r2.w) + asfloat(r4.w));
		r1.x = asint(1 / asfloat(r1.x));
		r2.x = asint(asfloat(r1.z) + asfloat(r1.y));
		r1.y = asint(asfloat(r0.w) * -2 + asfloat(r1.y));
		r1.z = asint(asfloat(r0.w) * -2 + asfloat(r1.z));
		r2.y = asint(asfloat(r6.w) + r7.w);
		r2.z = asint(asfloat(r5.w) + r7.w);
		r3.x = asint(asfloat(r2.w) * -2 + asfloat(r2.y));
		r2.z = asint(asfloat(r3.w) * -2 + asfloat(r2.z));
		r3.y = asint(asfloat(r5.w) + r8.w);
		r3.z = asint(asfloat(r6.w) + r8.w);
		r1.y = asint(abs(asfloat(r1.y)) * 2 + abs(asfloat(r3.x)));
		r1.z = asint(abs(asfloat(r1.z)) * 2 + abs(asfloat(r2.z)));
		r2.z = asint(asfloat(r4.w) * -2 + asfloat(r3.y));
		r3.x = asint(asfloat(r1.w) * -2 + asfloat(r3.z));
		r1.y = asint(asfloat(r1.y) + abs(asfloat(r2.z)));
		r1.z = asint(asfloat(r1.z) + abs(asfloat(r3.x)));
		r2.y = asint(asfloat(r2.y) + asfloat(r3.y));
		r1.y = (asfloat(r1.y) >= asfloat(r1.z)) ? -1 : 0;
		r1.z = asint(asfloat(r2.x) * 2 + asfloat(r2.y));
		r2.x = (r1.y != 0) ? r3.w : r4.w;
		r1.w = (r1.y != 0) ? r1.w : r2.w;
		r2.y = asint((r1.y != 0) ? globalScreenSize.w : globalScreenSize.z);
		r1.z = asint(asfloat(r1.z) * 0.0833333358 + -(asfloat(r0.w)));
		r2.z = asint(-(asfloat(r0.w)) + asfloat(r2.x));
		r2.w = asint(-(asfloat(r0.w)) + asfloat(r1.w));
		r2.x = asint(asfloat(r0.w) + asfloat(r2.x));
		r1.w = asint(asfloat(r0.w) + asfloat(r1.w));
		r3.x = (abs(asfloat(r2.z)) >= abs(asfloat(r2.w))) ? -1 : 0;
		r2.z = asint(max(abs(asfloat(r2.w)), abs(asfloat(r2.z))));
		r2.y = (r3.x != 0) ? asint(-(asfloat(r2.y))) : r2.y;
		r1.x = asint(saturate(asfloat(r1.x) * abs(asfloat(r1.z))));
		r1.z = r1.y & asint(globalScreenSize.z);
		r2.w = (r1.y != 0) ? 0 : asint(globalScreenSize.w);
		r3.yz = asint(asfloat(r2.yy) * float2(0.5, 0.5) + i.texcoord.xy);
		r3.y = (r1.y != 0) ? asint(i.texcoord.x) : r3.y;
		r3.z = (r1.y != 0) ? r3.z : asint(i.texcoord.y);
		r4.x = asint(-(asfloat(r1.z)) + asfloat(r3.y));
		r4.y = asint(-(asfloat(r2.w)) + asfloat(r3.z));
		r5.x = asint(asfloat(r1.z) + asfloat(r3.y));
		r5.y = asint(asfloat(r2.w) + asfloat(r3.z));
		r3.y = asint(asfloat(r1.x) * -2 + 3);
		r6 = asint(BackBuffer.SampleLevel(BackBufferSampler, asfloat(r4.xy), 0));
		r1.x = asint(asfloat(r1.x) * asfloat(r1.x));
		r7 = BackBuffer.SampleLevel(BackBufferSampler, asfloat(r5.xy), 0);
		r1.w = (r3.x != 0) ? r2.x : r1.w;
		r2.x = asint(asfloat(r2.z) * 0.25);
		r2.z = asint(-(asfloat(r1.w)) * 0.5 + asfloat(r0.w));
		r1.x = asint(asfloat(r1.x) * asfloat(r3.y));
		r2.z = (asfloat(r2.z) < 0) ? -1 : 0;
		r3.y = asint(-(asfloat(r1.w)) * 0.5 + asfloat(r6.w));
		r3.x = asint(-(asfloat(r1.w)) * 0.5 + r7.w);
		r4.zw = (abs(asfloat(r3.yx)) >= asfloat(r2.xx)) ? -1 : 0;
		r5.z = asint(-(asfloat(r1.z)) + asfloat(r4.x));
		r5.z = (r4.z != 0) ? r4.x : r5.z;
		r4.x = asint(-(asfloat(r2.w)) + asfloat(r4.y));
		r5.w = (r4.z != 0) ? r4.y : r4.x;
		r4.xy = ~r4.zw;
		r4.x = r4.y | r4.x;
		r4.y = asint(asfloat(r1.z) + asfloat(r5.x));
		r6.x = (r4.w != 0) ? r5.x : r4.y;
		r4.y = asint(asfloat(r2.w) + asfloat(r5.y));
		r6.y = (r4.w != 0) ? r5.y : r4.y;
		if (r4.x != 0) {
			if (r4.z == 0) {
				r7 = BackBuffer.SampleLevel(BackBufferSampler, asfloat(r5.zw), 0).wxyz;
			} else {
				r7.x = asfloat(r3.y);
			}
			if (r4.w == 0) {
				r3 = asint(BackBuffer.SampleLevel(BackBufferSampler, asfloat(r6.xy), 0).wxyz);
			}
			r3.z = asint(-(asfloat(r1.w)) * 0.5 + r7.x);
			r3.y = (r4.z != 0) ? asint(r7.x) : r3.z;
			r1.w = asint(-(asfloat(r1.w)) * 0.5 + asfloat(r3.x));
			r3.x = (r4.w != 0) ? r3.x : r1.w;
			r3.zw = (abs(asfloat(r3.yx)) >= asfloat(r2.xx)) ? -1 : 0;
			r1.w = asint(-(asfloat(r1.z)) + asfloat(r5.z));
			r5.z = (r3.z != 0) ? r5.z : r1.w;
			r1.w = asint(-(asfloat(r2.w)) + asfloat(r5.w));
			r5.w = (r3.z != 0) ? r5.w : r1.w;
			r1.z = asint(asfloat(r1.z) + asfloat(r6.x));
			r6.x = (r3.w != 0) ? r6.x : r1.z;
			r1.z = asint(asfloat(r2.w) + asfloat(r6.y));
			r6.y = (r3.w != 0) ? r6.y : r1.z;
		}
		r1.z = asint(-(asfloat(r5.z)) + i.texcoord.x);
		r1.w = asint(asfloat(r6.x) + -(i.texcoord.x));
		r2.x = asint(-(asfloat(r5.w)) + i.texcoord.y);
		r1.z = (r1.y != 0) ? r1.z : r2.x;
		r2.x = asint(asfloat(r6.y) + -(i.texcoord.y));
		r1.w = (r1.y != 0) ? r1.w : r2.x;
		r2.xw = (asfloat(r3.yx) < float2(0, 0)) ? -1 : 0;
		r3.x = asint(asfloat(r1.z) + asfloat(r1.w));
		r2.xz = (r2.xw != r2.zz) ? -1 : 0;
		r2.w = asint(1 / asfloat(r3.x));
		r3.x = (asfloat(r1.z) < asfloat(r1.w)) ? -1 : 0;
		r1.z = asint(min(asfloat(r1.w), asfloat(r1.z)));
		r1.w = (r3.x != 0) ? r2.x : r2.z;
		r1.x = asint(asfloat(r1.x) * asfloat(r1.x));
		r1.z = asint(asfloat(r1.z) * -(asfloat(r2.w)) + 0.5);
		r1.x = asint(asfloat(r1.x) * 0.75);
		r1.z = r1.z & r1.w;
		r1.x = asint(max(asfloat(r1.x), asfloat(r1.z)));
		r1.xz = asint(asfloat(r1.xx) * asfloat(r2.yy) + i.texcoord.xy);
		r2.x = (r1.y != 0) ? asint(i.texcoord.x) : r1.x;
		r2.y = (r1.y != 0) ? r1.z : asint(i.texcoord.y);
		r1 = asint(BackBuffer.SampleLevel(BackBufferSampler, asfloat(r2.xy), 0));
		r0.xyz = r1.xyz;
	}
	o = saturate(asfloat(r0));

	return o;
}
