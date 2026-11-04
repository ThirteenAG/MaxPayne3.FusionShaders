cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer direction_light : register(b10)
{
	float4 gDepthFxParams : packoffset(c0);
};

cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
	float4 globalScalars2 : packoffset(c1);
	float4 globalScalars3 : packoffset(c2);
	float4 globalScalars4 : packoffset(c3);
	float4 globalFogParams : packoffset(c4);
};

cbuffer UserClipPlanes : register(b6)
{
	float4 g_vUserClipPlanes[8] : packoffset(c0);
};

cbuffer glass_matrices : register(b1)
{
	row_major float3x4 gGlassMtx[1024] : packoffset(c0);
};

cbuffer BreakableGlass : register(b4)
{
	float4 BrokenColor : packoffset(c0);
	float4 PaneColor : packoffset(c1);
	float4 CrackMatrix : packoffset(c2);
	float4 CrackOffset : packoffset(c3);
};

struct VS_IN
{
	float3 position : POSITION;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
	float3 normal : NORMAL;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
	float4 texcoord6 : TEXCOORD6;
	float4 texcoord9 : TEXCOORD9;
	float sv_clipdistance : SV_ClipDistance;
	float4 color1 : COLOR1;
	float4 texcoord2 : TEXCOORD2;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	int4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	r0.x = (0.5 < CrackOffset.w) ? -1 : 0;
	if (r0.x != 0) {
		r0.x = asint(i.color.w * 255);
		r0.x = asint(round(asfloat(r0.x)));
		r0.x = (uint)asfloat(r0.x);
		r0.x = r0.x * 3;
		r0.y = asint(dot(gGlassMtx[r0.x / 3][0].xyz, gGlassMtx[r0.x / 3][0].xyz));
		r0.y = asint(sqrt(asfloat(r0.y)));
		r0.z = (0 < asfloat(r0.y)) ? -1 : 0;
		if (r0.z != 0) {
			r1.xyz = asint(gGlassMtx[r0.x / 3][0].xyz / asfloat(r0.yyy));
			r2.xyz = gGlassMtx[r0.x / 3][1].xyz / asfloat(r0.yyy);
			r3.xyz = gGlassMtx[r0.x / 3][2].xyz / asfloat(r0.yyy);
		} else {
			r1.xyz = asint(gGlassMtx[r0.x / 3][0].xyz);
			r2.xyz = gGlassMtx[r0.x / 3][1].xyz;
			r3.xyz = gGlassMtx[r0.x / 3][2].xyz;
		}
		r1.w = asint(gGlassMtx[r0.x / 3][0].w);
		r4.xyz = i.position.xyz;
		r4.w = 1;
		r0.z = asint(dot(asfloat(r1), r4));
		r2.w = gGlassMtx[r0.x / 3][1].w;
		r0.w = asint(dot(r2, r4));
		r3.w = gGlassMtx[r0.x / 3][2].w;
		r0.x = asint(dot(r3, r4));
		r1.x = asint(dot(asfloat(r1.xyz), i.normal.xyz));
		r1.y = asint(dot(r2.xyz, i.normal.xyz));
		r1.z = asint(dot(r3.xyz, i.normal.xyz));
		o.color1.xy = i.color.xy;
		o.color1.w = 0;
		o.color1.z = asfloat(r0.y);
	} else {
		o.color1 = float4(0, 0, 0, 0);
		r0.xzw = asint(i.position.zxy);
		r1.xyz = asint(i.normal.xyz);
	}
	r2.xyz = asfloat(r0.www) * gWorld[1].xyz;
	r2.xyz = asfloat(r0.zzz) * gWorld[0].xyz + r2.xyz;
	r2.xyz = asfloat(r0.xxx) * gWorld[2].xyz + r2.xyz;
	r2.xyz = r2.xyz + gWorld[3].xyz;
	o.texcoord3 = -(r2.xyz) + gViewInverse[3].xyz;
	r3.xyz = asfloat(r1.yyy) * gWorld[1].xyz;
	r1.xyw = asint(asfloat(r1.xxx) * gWorld[0].xyz + r3.xyz);
	r1.xyz = asint(asfloat(r1.zzz) * gWorld[2].xyz + asfloat(r1.xyw));
	r1.xyz = asint(asfloat(r1.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.y = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r0.y = asint(rsqrt(asfloat(r0.y)));
	o.texcoord1.xyz = asfloat(r0.yyy) * asfloat(r1.xyz);
	r1 = asint(asfloat(r0.w) * gWorldViewProj[1]);
	r1 = asint(asfloat(r0.z) * gWorldViewProj[0] + asfloat(r1));
	r0 = asint(asfloat(r0.x) * gWorldViewProj[2] + asfloat(r1));
	r0 = asint(asfloat(r0) + gWorldViewProj[3]);
	r1.x = asint(g_vUserClipPlanes[0].y + g_vUserClipPlanes[0].x);
	r1.x = asint(asfloat(r1.x) + g_vUserClipPlanes[0].z);
	r1.x = asint(asfloat(r1.x) + g_vUserClipPlanes[0].w);
	r1.x = (asfloat(r1.x) != 0) ? -1 : 0;
	r2.w = 1;
	r1.y = asint(dot(r2, g_vUserClipPlanes[0]));
	o.sv_clipdistance = (r1.x != 0) ? asfloat(r1.y) : 1;
	r1.xyz = asint(r2.xyz + -(gViewInverse[3].xyz));
	r1.w = asint(asfloat(r1.z) * globalFogParams.x);
	r1.x = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r1.x = asint(sqrt(asfloat(r1.x)));
	r1.x = asint(asfloat(r1.x) * globalFogParams.z);
	r1.y = (0.0000999999975 < abs(asfloat(r1.w))) ? -1 : 0;
	r1.z = asint(asfloat(r1.w) * -1.44269502);
	r1.z = asint(exp2(asfloat(r1.z)));
	r1.z = asint(-(asfloat(r1.z)) + 1);
	r1.z = asint(asfloat(r1.z) / asfloat(r1.w));
	r1.z = asint(asfloat(r1.z) * asfloat(r1.x));
	r1.x = (r1.y != 0) ? r1.z : r1.x;
	r1.x = asint(asfloat(r1.x) * -(globalFogParams.y));
	r1.x = asint(asfloat(r1.x) * 1.44269502);
	r1.x = asint(exp2(asfloat(r1.x)));
	o.texcoord9.x = -(asfloat(r1.x)) + 1;
	r1.x = asint(saturate(-(asfloat(r0.w)) * gDepthFxParams.z + gDepthFxParams.w));
	r1.y = asint(-(asfloat(r1.x)) + 1);
	r1.x = asint(asfloat(r1.y) * gDepthFxParams.y + asfloat(r1.x));
	o.texcoord9.y = asfloat(r1.x) + -1;
	o.sv_position = asfloat(r0);
	o.color = float4(1, 1, 1, 1);
	o.texcoord1.w = asfloat(r0.w);
	o.texcoord6 = r2;
	o.texcoord9.zw = float2(0, 0);
	o.texcoord2.xy = i.texcoord.zw;
	o.texcoord2.zw = i.texcoord1.xy;
	o.texcoord = i.texcoord.xy;

	return o;
}
