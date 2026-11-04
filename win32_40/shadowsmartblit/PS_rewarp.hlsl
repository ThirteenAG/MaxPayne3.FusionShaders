SamplerState HemiCubeSampler : register(s0);
Texture2D HemiCubeSampler_tex : register(t0);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	int4 r1;
	float4 r2;
	int3 r3;
	r0.xy = asint(i.texcoord.xy + float2(-0.5, -0.5));
	r0.zw = asint(asfloat(r0.xy) * float2(2, 2) + float2(0.00000999999975, 0.00000999999975));
	r0.xy = asint(asfloat(r0.xy) + asfloat(r0.xy));
	r1.z = asint(dot(asfloat(r0.xy), asfloat(r0.xy)));
	r0.x = asint(dot(asfloat(r0.zw), asfloat(r0.zw)));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	r0.xy = asint(asfloat(r0.xx) * asfloat(r0.zw));
	r0.z = 1065353216;
	r1.xy = asint(i.texcoord.xy * float2(2, 2) + float2(-1, -1));
	r0.w = (1 < asfloat(r1.z)) ? -1 : 0;
	r0.xyz = (r0.www != 0) ? r0.xyz : r1.xyz;
	r0.xy = asint(asfloat(r0.xy) + asfloat(r0.xy));
	r0.zw = asint(asfloat(r0.zz) + float2(1, -1));
	r1.xyz = asint(asfloat(r0.wxy) / asfloat(r0.zzz));
	r0.x = asint(max(abs(asfloat(r1.z)), abs(asfloat(r1.y))));
	r0.x = asint(max(asfloat(r0.x), abs(asfloat(r1.x))));
	r0.x = asint(1 / asfloat(r0.x));
	r0.yz = asint(asfloat(r0.xx) * asfloat(r1.yx));
	r2 = asfloat(r0.x) * asfloat(r1.yzxz);
	r3 = (abs(asfloat(r1.xxy)) >= abs(asfloat(r1.yzz))) ? -1 : 0;
	r1 = (float4(0, 0, 0, 0) < asfloat(r1.yyzz)) ? -1 : 0;
	r1 = (r1 != 0) ? int4(0, 1065353216, 1065353216, 0) : int4(1065353216, 0, 0, 1065353216);
	r1 = (r3.z != 0) ? r1.xyxy : r1.zwzw;
	r0.xy = (r3.zz != 0) ? asint(r2.zw) : r0.yz;
	r0.z = r3.y & r3.x;
	r0.xy = (r0.zz != 0) ? asint(r2.xy) : r0.xy;
	r0.w = r0.z | r3.z;
	r2 = (r3.z != 0) ? float4(-0.25, 1, 0.75, 1) : float4(0.25, 1, 1.25, 1);
	r2 = (r0.z != 0) ? float4(0.25, 1, 0.25, 1) : r2;
	r1 = (r0.z != 0) ? int4(1065353216, 0, 0, 1065353216) : r1;
	r0.zw = (r0.ww != 0) ? int2(1048576000, 1065353216) : int2(1048576000, -1082130432);
	r0.zw = asint(asfloat(r0.xy) * asfloat(r0.zw) + r2.zw);
	r2.xy = asfloat(r0.xy) * r2.xy + r2.zw;
	r0.x = asint(dot(asfloat(r0.xy), asfloat(r0.xy)));
	r0.x = asint(asfloat(r0.x) + 1);
	r0.x = asint(sqrt(asfloat(r0.x)));
	r2.xy = r2.xy * float2(0.666666687, 0.5);
	r2 = HemiCubeSampler_tex.Sample(HemiCubeSampler, r2.xy);
	r0.y = asint(dot(r2.xy, asfloat(r1.zw)));
	o.y = asfloat(r0.x) * asfloat(r0.y);
	r0.yz = asint(asfloat(r0.zw) * float2(0.666666687, 0.5));
	r2 = HemiCubeSampler_tex.Sample(HemiCubeSampler, asfloat(r0.yz));
	r0.y = asint(dot(r2.xy, asfloat(r1.xy)));
	o.x = asfloat(r0.x) * asfloat(r0.y);
	o.zw = float2(0, 1);

	return o;
}
