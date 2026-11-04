cbuffer _Globals : register(b0)
{
	float2 facetMask[4] : packoffset(c204);
};

cbuffer rage_matrices : register(b1)
{
	row_major float4x4 gWorld : packoffset(c0);
};

cbuffer ShadowParam : register(b10)
{
	float4 gShadowParam18192021 : packoffset(c0);
	float4 gFacetCentre : packoffset(c1);
	float4 gShadowParam14151617 : packoffset(c2);
	float4 gShadowParam0123 : packoffset(c3);
	float4 gShadowParam4567 : packoffset(c4);
	float4 gShadowParam891113 : packoffset(c5);
	row_major float4x4 gShadowMatrix : packoffset(c6);
};

struct VS_IN
{
	float3 position : POSITION;
	float4 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	int4 r1;
	int4 r2;
	float4 r3;
	float3 r4;
	r0.xyz = asint(i.position.yyy * gWorld[1].xyz);
	r0.xyz = asint(i.position.xxx * gWorld[0].xyz + asfloat(r0.xyz));
	r0.xyz = asint(i.position.zzz * gWorld[2].xyz + asfloat(r0.xyz));
	r0.xyz = asint(asfloat(r0.xyz) + gWorld[3].xyz);
	r1.xy = (gShadowParam14151617.xx == float2(0, 3)) ? -1 : 0;
	if (r1.x != 0) {
		r2.xyz = asint(asfloat(r0.yyy) * gShadowMatrix[1].xyz);
		r2.xyz = asint(asfloat(r0.xxx) * gShadowMatrix[0].xyz + asfloat(r2.xyz));
		r2.xyz = asint(asfloat(r0.zzz) * gShadowMatrix[2].xyz + asfloat(r2.xyz));
		r2.xyz = asint(asfloat(r2.xyz) + gShadowMatrix[3].xyz);
		r0.w = asint(asfloat(r2.z) + gShadowParam891113.z);
		r1.z = (gShadowParam14151617.y == 0) ? -1 : 0;
		r1.z = (r1.z != 0) ? 1056964608 : -1090519040;
		r2.w = asint(dot(asfloat(r1.zz), asfloat(r0.ww)));
		r0.w = asint(dot(asfloat(r2.xyw), asfloat(r2.xyw)));
		r0.w = asint(sqrt(asfloat(r0.w)));
		r1.z = asint(-(asfloat(r2.w)) + asfloat(r0.w));
		r3.xy = asfloat(r2.xy) / asfloat(r1.zz);
		r3.w = asfloat(r2.w) * -(gShadowParam0123.w);
		r3.z = asfloat(r0.w) * -(gShadowParam0123.w);
	} else {
		r0.w = (gShadowParam14151617.x == 1) ? -1 : 0;
		if (r0.w != 0) {
			r2.xyz = asint(asfloat(r0.yyy) * gShadowMatrix[1].xyz);
			r2.xyz = asint(asfloat(r0.xxx) * gShadowMatrix[0].xyz + asfloat(r2.xyz));
			r2.xyz = asint(asfloat(r0.zzz) * gShadowMatrix[2].xyz + asfloat(r2.xyz));
			r2.xyz = asint(asfloat(r2.xyz) + gShadowMatrix[3].xyz);
			r4.z = asfloat(r2.z) * gShadowParam0123.w;
			r2.w = 1056964608;
			r4.xy = gShadowParam0123.zz;
			r3.xyz = asfloat(r2.xyw) * r4.xyz;
			r0.w = (uint)gShadowParam14151617.y;
			r0.w = asint(dot(r3.xy, facetMask[r0.w].xy));
			r3.w = asfloat(r0.w) + 2;
			r3.z = max(r3.z, 0);
		} else {
			r2.xyz = asint(asfloat(r0.yyy) * gShadowMatrix[1].xyz);
			r2.xyz = asint(asfloat(r0.xxx) * gShadowMatrix[0].xyz + asfloat(r2.xyz));
			r2.xyz = asint(asfloat(r0.zzz) * gShadowMatrix[2].xyz + asfloat(r2.xyz));
			r2.xyz = asint(asfloat(r2.xyz) + gShadowMatrix[3].xyz);
			r3.xy = asfloat(r2.xy) * gShadowParam0123.zz;
			r3.w = asfloat(asint(-(asfloat(r2.z))));
			r0.w = asint(gShadowParam0123.x + -(gShadowParam891113.w));
			r1.z = asint(gShadowParam891113.w / asfloat(r0.w));
			r1.w = asint(gShadowParam0123.x * gShadowParam891113.w);
			r0.w = asint(asfloat(r1.w) / asfloat(r0.w));
			r3.z = asfloat(r2.z) * asfloat(r1.z) + asfloat(r0.w);
		}
	}
	r0.w = asint(r3.w * -(gShadowParam0123.w));
	r2.z = (r1.y != 0) ? r0.w : asint(r3.w);
	r4.x = 1;
	r4.yz = r3.wz;
	r2.x = asint(r4.y);
	r2.y = r0.z;
	r1.xyz = (r1.xxx != 0) ? asint(r4.xyz) : r2.xyz;
	o.sv_position.xyz = r3.xyz;
	o.sv_position.w = asfloat(r1.x);
	o.texcoord1.xy = asfloat(r0.xy);
	o.texcoord1.zw = asfloat(r1.yz);
	o.texcoord = i.texcoord;

	return o;
}
